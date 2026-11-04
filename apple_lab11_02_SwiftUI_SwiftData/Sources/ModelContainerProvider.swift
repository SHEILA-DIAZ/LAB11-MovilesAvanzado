import Foundation
import SwiftData

@MainActor
class ModelContainerProvider {
    static let shared = ModelContainerProvider()
    let container: ModelContainer

    private init() {
        let schema = Schema([Alumno.self])
        do {
            let directory = try FileManager.default.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask, appropriateFor: nil, create: true)
            let config = ModelConfiguration("AlumnosData", schema: schema,
                                            url: directory.appendingPathComponent("AlumnosData.sqlite"))
            print("Base de datos SQLite en: \(config.url.path)")
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
