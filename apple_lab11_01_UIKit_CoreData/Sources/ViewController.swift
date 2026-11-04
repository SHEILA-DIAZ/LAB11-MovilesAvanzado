import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var TablaContacto: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        let delegate = UIApplication.shared.delegate as! AppDelegate
        print("Base de datos SQLite en: \(delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta")")
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
}
