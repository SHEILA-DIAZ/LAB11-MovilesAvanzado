import UIKit
import CoreData

extension ViewController: UISearchResultsUpdating {
    // El mismo fetch combina búsqueda [cd], ordenamiento y filtro por relación.
    func consultarContactos(texto: String = "", nombreGrupo: String? = nil) throws -> [Contacto] {
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        var filtros = [NSPredicate]()
        if !texto.isEmpty { filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto)) }
        if let nombreGrupo { filtros.append(NSPredicate(format: "grupo.nombre == %@", nombreGrupo)) }
        if !filtros.isEmpty { request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros) }
        return try conexion().fetch(request)
    }

    func buscarContactos(texto: String) -> [Contacto] {
        do { return try consultarContactos(texto: texto) }
        catch { mostrarError(error); return [] }
    }

    func contactosDelGrupo(_ nombreGrupo: String) -> [Contacto] {
        do { return try consultarContactos(nombreGrupo: nombreGrupo) }
        catch { mostrarError(error); return [] }
    }

    func updateSearchResults(for searchController: UISearchController) { cargarInfoCoreData() }

    @objc func alternarGrupo() {
        soloAmigos.toggle()
        toolbarItems?.first(where: { $0.accessibilityIdentifier == "filtroGrupo" })?.title = soloAmigos ? "Ver todos" : "Ver Amigos"
        cargarInfoCoreData()
    }

    @objc func asignarGrupoDemo() { probarRelacion() }

    // Acción voluntaria: reutiliza Amigos y asigna el primer contacto visible.
    // No se ejecuta al iniciar ni genera grupos vacíos si aún no hay contactos.
    func probarRelacion() {
        guard let primero = contactos.first else { return }
        let contexto = conexion()
        do {
            let request: NSFetchRequest<Grupo> = Grupo.fetchRequest()
            request.predicate = NSPredicate(format: "nombre == %@", "Amigos")
            request.fetchLimit = 1
            let grupo = try contexto.fetch(request).first ?? Grupo(context: contexto)
            grupo.nombre = "Amigos"
            primero.grupo = grupo
            try contexto.save()
            print("El grupo \(grupo.nombre ?? "") tiene \(grupo.contactos?.count ?? 0) contacto(s)")
            cargarInfoCoreData()
        } catch {
            contexto.rollback()
            mostrarError(error)
        }
    }
}
