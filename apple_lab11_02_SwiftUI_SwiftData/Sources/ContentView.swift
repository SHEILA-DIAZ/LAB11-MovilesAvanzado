import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]

    var body: some View {
        NavigationStack {
            List(alumnos) { alumno in
                Text("\(alumno.apellido), \(alumno.nombre)")
            }
            .navigationTitle("Alumnos")
        }
    }
}

#Preview {
    ContentView().modelContainer(for: [Alumno.self], inMemory: true)
}
