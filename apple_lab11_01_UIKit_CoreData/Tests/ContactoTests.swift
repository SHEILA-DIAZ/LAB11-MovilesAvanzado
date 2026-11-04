import XCTest
import CoreData
import UIKit
@testable import apple_lab11_01_UIKit_CoreData

final class ContactoTests: XCTestCase {
    @MainActor
    func testConsultasDelControladorYDemoSinDuplicados() throws {
        let modelo = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: modelo)
        try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
        context.persistentStoreCoordinator = coordinator
        let controller = ControladorDePrueba()
        controller.contextoDePrueba = context
        controller.probarRelacion()
        XCTAssertEqual(try context.count(for: Grupo.fetchRequest()), 0)
        for nombre in ["Zoe", "Juán", "Ana"] {
            let contacto = Contacto(context: context)
            contacto.nombre = nombre
        }
        try context.save()
        XCTAssertEqual(try controller.consultarContactos().map(\.nombre), ["Ana", "Juán", "Zoe"])
        XCTAssertEqual(controller.buscarContactos(texto: "JUAN").map(\.nombre), ["Juán"])
        XCTAssertTrue(controller.buscarContactos(texto: "inexistente").isEmpty)
        controller.contactos = controller.buscarContactos(texto: "JUAN")
        controller.probarRelacion()
        controller.probarRelacion()
        XCTAssertEqual(try context.count(for: Grupo.fetchRequest()), 1)
        XCTAssertEqual(controller.contactosDelGrupo("Amigos").map(\.nombre), ["Juán"])
        XCTAssertTrue(try controller.consultarContactos(texto: "Zoe", nombreGrupo: "Amigos").isEmpty)
        let grupo = try XCTUnwrap(context.fetch(Grupo.fetchRequest()).first)
        XCTAssertEqual(grupo.contactos?.count, 1)
        let relacion = try XCTUnwrap(modelo.entitiesByName["Grupo"]?.relationshipsByName["contactos"])
        XCTAssertTrue(relacion.isToMany)
        XCTAssertEqual(relacion.deleteRule, .nullifyDeleteRule)
        XCTAssertEqual(relacion.inverseRelationship?.name, "grupo")
    }

    @MainActor
    func testSQLiteCRUDOrdenBusquedaRelacionYNullify() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("Contactos.sqlite")
        // Reutilizar el modelo de la app evita registrar dos descripciones para Contacto.
        let model = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
        var abiertos = [NSPersistentContainer]()
        defer {
            for container in abiertos {
                container.viewContext.reset()
                for store in container.persistentStoreCoordinator.persistentStores {
                    try? container.persistentStoreCoordinator.remove(store)
                }
            }
            try? FileManager.default.removeItem(at: directory)
        }
        func abrir() throws -> NSPersistentContainer {
            let container = NSPersistentContainer(name: "Prueba", managedObjectModel: model)
            let description = NSPersistentStoreDescription(url: url)
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
            var failure: Error?
            container.loadPersistentStores { _, error in failure = error }
            if let failure { throw failure }
            abiertos.append(container)
            return container
        }
        let container = try abrir()
        let context = container.viewContext
        let grupo = Grupo(context: context)
        grupo.nombre = "Amigos"
        for nombre in ["Zoe", "Ana", "Juán"] {
            let contacto = Contacto(context: context)
            contacto.nombre = nombre
            contacto.telefono = "999123456"
            contacto.direccion = "Tecsup"
            contacto.grupo = grupo
        }
        try context.save()
        XCTAssertEqual(grupo.contactos?.count, 3)
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        XCTAssertEqual(try context.fetch(request).map(\.nombre), ["Ana", "Juán", "Zoe"])
        request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ AND grupo.nombre == %@", "juan", "Amigos")
        let juan = try XCTUnwrap(context.fetch(request).first)
        juan.telefono = "111"
        try context.save()
        // Nuevo contenedor: lectura real desde el archivo, sin compartir el contexto.
        let reopened = try abrir()
        XCTAssertEqual(try reopened.viewContext.fetch(request).first?.telefono, "111")
        context.delete(grupo)
        try context.save()
        request.predicate = nil
        XCTAssertEqual(try context.count(for: request), 3)
        XCTAssertTrue(try context.fetch(request).allSatisfy { $0.grupo == nil })
        context.delete(juan)
        try context.save()
        XCTAssertEqual(try abrir().viewContext.count(for: request), 2)
    }
}

private final class ControladorDePrueba: ViewController {
    var contextoDePrueba: NSManagedObjectContext!
    override func conexion() -> NSManagedObjectContext { contextoDePrueba }
    // Probar las consultas reales sin cargar un Storyboard ni usar datos del usuario.
    override func cargarInfoCoreData() {}
    override func mostrarError(_ error: Error) { XCTFail("Consulta fallida: \(error)") }
}
