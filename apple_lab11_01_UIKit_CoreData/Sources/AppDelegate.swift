import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // El nombre coincide con el modelo .xcdatamodeld; el almacén es SQLite en disco.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "apple_lab11_01_UIKit_CoreData")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Error al abrir Core Data: \(error)")
            }
        }
        return container
    }()

    func applicationDidEnterBackground(_ application: UIApplication) {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do { try context.save() }
        catch { print("Error al guardar Core Data: \(error)") }
    }
}
