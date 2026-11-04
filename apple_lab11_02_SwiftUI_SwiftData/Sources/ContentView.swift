import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]
    @State private var alumnoSeleccionado: Alumno?
    @State private var mostrarFormulario = false
    @State private var errorMensaje: String?

    var body: some View {
        NavigationSplitView {
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnos) { alumno in
                    NavigationLink(value: alumno) {
                        VStack(alignment: .leading) {
                            Text("\(alumno.apellido), \(alumno.nombre)").font(.headline)
                            Text("DNI: \(alumno.dni)").font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlumnos)
            }
            .navigationTitle("Alumnos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { EditButton() }
                ToolbarItem {
                    Button { mostrarFormulario = true } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                    .accessibilityIdentifier("nuevoAlumno")
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Detalles del Alumno").font(.title2)
                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
                }.padding()
            } else {
                Text("Selecciona un alumno")
            }
        }
        .sheet(isPresented: $mostrarFormulario) { NuevoAlumnoView() }
        .alert("No se pudo guardar", isPresented: Binding(get: { errorMensaje != nil },
                                                         set: { if !$0 { errorMensaje = nil } })) {
            Button("Aceptar", role: .cancel) { errorMensaje = nil }
        } message: { Text(errorMensaje ?? "") }
    }

    private func deleteAlumnos(offsets: IndexSet) {
        // Tomar una instantánea antes de que @Query cambie los índices.
        let seleccion = offsets.map { alumnos[$0] }
        for alumno in seleccion {
            if alumnoSeleccionado == alumno { alumnoSeleccionado = nil }
            modelContext.delete(alumno)
        }
        do { try modelContext.save() }
        catch {
            modelContext.rollback()
            errorMensaje = error.localizedDescription
        }
    }
}

#Preview {
    ContentView().modelContainer(for: [Alumno.self], inMemory: true)
}
