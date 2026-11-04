import XCTest
import SwiftData
@testable import apple_lab11_02_SwiftUI_SwiftData

final class AlumnoTests: XCTestCase {
    @MainActor
    func testSQLiteCRUDRelacionPersistenciaYNullify() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let schema = Schema([Alumno.self, Curso.self])
        let config = ModelConfiguration("Prueba", schema: schema, url: directory.appendingPathComponent("Alumnos.sqlite"))
        try autoreleasepool {
            let container = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(container)
            context.autosaveEnabled = false
            let curso = Curso(nombre: "Programación en Móviles")
            context.insert(curso)
            for apellido in ["Torres", "Garcia", "Alva"] {
                let alumno = Alumno(apellido: apellido, nombre: "Ana", dni: "12345678")
                context.insert(alumno)
                alumno.curso = curso
            }
            try context.save()
            XCTAssertEqual(curso.alumnos.count, 3)
            let request = FetchDescriptor<Alumno>(sortBy: [SortDescriptor(\Alumno.apellido)])
            XCTAssertEqual(try context.fetch(request).map(\.apellido), ["Alva", "Garcia", "Torres"])
            let alumno = try XCTUnwrap(context.fetch(request).first)
            alumno.nombre = "Editado"
            try context.save()
        }
        try autoreleasepool {
            let reopened = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(reopened)
            context.autosaveEnabled = false
            let request = FetchDescriptor<Alumno>(sortBy: [SortDescriptor(\Alumno.apellido)])
            let alumnos = try context.fetch(request)
            XCTAssertEqual(alumnos.count, 3)
            XCTAssertEqual(alumnos.first?.nombre, "Editado")
            XCTAssertTrue(alumnos.allSatisfy { $0.curso?.nombre == "Programación en Móviles" })
            let filtrados = alumnos.filter { $0.apellido.localizedCaseInsensitiveContains("GAR") }
            XCTAssertEqual(filtrados.map(\.apellido), ["Garcia"])
            // Borrar usando la lista filtrada debe eliminar Garcia, no Alva.
            context.delete(try XCTUnwrap(filtrados.first))
            try context.save()
            let curso = try XCTUnwrap(context.fetch(FetchDescriptor<Curso>()).first)
            context.delete(curso)
            try context.save()
        }
        try autoreleasepool {
            let reopened = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(reopened)
            let alumnos = try context.fetch(FetchDescriptor<Alumno>())
            XCTAssertEqual(Set(alumnos.map(\.apellido)), ["Alva", "Torres"])
            XCTAssertTrue(alumnos.allSatisfy { $0.curso == nil })
            XCTAssertEqual(try context.fetchCount(FetchDescriptor<Curso>()), 0)
        }
    }
}
