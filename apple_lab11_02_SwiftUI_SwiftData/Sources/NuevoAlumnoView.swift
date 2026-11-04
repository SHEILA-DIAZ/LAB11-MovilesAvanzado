import SwiftUI
import SwiftData

struct NuevoAlumnoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var apellido = ""
    @State private var nombre = ""
    @State private var dni = ""
    @State private var errorMensaje: String?

    private var datosCompletos: Bool {
        [apellido, nombre, dni].allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del Alumno") {
                    TextField("Apellido", text: $apellido).accessibilityIdentifier("apellido")
                    TextField("Nombre", text: $nombre).accessibilityIdentifier("nombre")
                    TextField("DNI", text: $dni)
                        .keyboardType(.numberPad).accessibilityIdentifier("dni")
                }
                Button("Guardar Alumno") {
                    let nuevo = Alumno(apellido: apellido.trimmingCharacters(in: .whitespacesAndNewlines),
                                       nombre: nombre.trimmingCharacters(in: .whitespacesAndNewlines),
                                       dni: dni.trimmingCharacters(in: .whitespacesAndNewlines))
                    modelContext.insert(nuevo)
                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        modelContext.rollback()
                        errorMensaje = error.localizedDescription
                    }
                }
                .disabled(!datosCompletos)
                .accessibilityIdentifier("guardarAlumno")
            }
            .navigationTitle("Nuevo Alumno")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .alert("No se pudo guardar", isPresented: Binding(get: { errorMensaje != nil },
                                                             set: { if !$0 { errorMensaje = nil } })) {
                Button("Aceptar", role: .cancel) { errorMensaje = nil }
            } message: { Text(errorMensaje ?? "") }
        }
    }
}
