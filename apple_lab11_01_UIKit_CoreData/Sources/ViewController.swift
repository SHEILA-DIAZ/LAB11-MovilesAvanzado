import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var TablaContacto: UITableView!
    var contactos = [Contacto]()
    let buscador = UISearchController(searchResultsController: nil)
    var soloAmigos = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let apariencia = UINavigationBarAppearance()
        apariencia.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = apariencia
        navigationController?.navigationBar.scrollEdgeAppearance = apariencia
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        TablaContacto.accessibilityIdentifier = "contactos"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "agregarContacto"
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        let grupo = UIBarButtonItem(title: "Grupo demo", style: .plain, target: self, action: #selector(asignarGrupoDemo))
        grupo.accessibilityIdentifier = "grupoDemo"
        let filtro = UIBarButtonItem(title: "Ver Amigos", style: .plain, target: self, action: #selector(alternarGrupo))
        filtro.accessibilityIdentifier = "filtroGrupo"
        toolbarItems = [grupo, UIBarButtonItem(systemItem: .flexibleSpace), filtro]
        navigationController?.isToolbarHidden = false
        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()
    }

    func conexion() -> NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func mostrarRutaBaseDeDatos() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta"
        print("Base de datos SQLite en: \(ruta)")
    }

    // READ: la tabla muestra el resultado del fetch, ordenado alfabéticamente.
    func cargarInfoCoreData() {
        do {
            contactos = try consultarContactos(texto: buscador.searchBar.text ?? "", nombreGrupo: soloAmigos ? "Amigos" : nil)
            TablaContacto.reloadData()
        } catch { mostrarError(error) }
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        presentarFormulario(contacto: nil)
    }

    // CREATE y UPDATE comparten los mismos tres campos del laboratorio.
    private func presentarFormulario(contacto: Contacto?) {
        let alert = UIAlertController(title: contacto == nil ? "Agregar Contacto" : "Editar Contacto",
                                      message: "Nombre, teléfono y dirección", preferredStyle: .alert)
        let campos = [("Nombre", contacto?.nombre), ("Telefono", contacto?.telefono),
                      ("Direccion", contacto?.direccion)]
        for (indice, campo) in campos.enumerated() {
            alert.addTextField {
                $0.placeholder = campo.0
                $0.text = campo.1
                $0.accessibilityIdentifier = campo.0
                if indice == 1 { $0.keyboardType = .phonePad }
            }
        }
        let guardar = UIAlertAction(title: contacto == nil ? "Aceptar" : "Guardar", style: .default) { _ in
            let nombre = (alert.textFields?[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !nombre.isEmpty else { return }
            let contexto = self.conexion()
            let entidad = contacto ?? (NSEntityDescription.insertNewObject(forEntityName: "Contacto", into: contexto) as! Contacto)
            entidad.nombre = nombre
            entidad.telefono = alert.textFields?[1].text ?? ""
            entidad.direccion = alert.textFields?[2].text ?? ""
            do {
                try contexto.save()
                self.cargarInfoCoreData()
            } catch {
                contexto.rollback()
                self.mostrarError(error)
            }
        }
        alert.addAction(guardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { contactos.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contacto = contactos[indexPath.row]
        celda.textLabel?.text = contacto.nombre
        celda.detailTextLabel?.text = "\(contacto.telefono ?? "") | \(contacto.direccion ?? "") | \(contacto.grupo?.nombre ?? "Sin grupo")"
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentarFormulario(contacto: contactos[indexPath.row])
    }

    // DELETE: se guarda antes de quitar la fila de la pantalla.
    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        contexto.delete(contactos[indexPath.row])
        do {
            try contexto.save()
            contactos.remove(at: indexPath.row)
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            contexto.rollback()
            mostrarError(error)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { eliminarContacto(at: indexPath) }
    }

    func mostrarError(_ error: Error) {
        print("Error Core Data: \(error)")
        let alert = UIAlertController(title: "No se pudo guardar o consultar", message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
