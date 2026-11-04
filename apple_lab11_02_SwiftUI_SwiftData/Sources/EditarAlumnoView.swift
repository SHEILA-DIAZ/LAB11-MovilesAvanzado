import SwiftUI
import SwiftData

struct EditarAlumnoView: View {
    @Bindable var alumno: Alumno
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var errorMensaje: String?

    private var datosCompletos: Bool {
        [alumno.apellido, alumno.nombre, alumno.dni].allSatisfy {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del Alumno") {
                    TextField("Apellido", text: $alumno.apellido).accessibilityIdentifier("apellido")
                    TextField("Nombre", text: $alumno.nombre).accessibilityIdentifier("nombre")
                    TextField("DNI", text: $alumno.dni)
                        .keyboardType(.numberPad).accessibilityIdentifier("dni")
                }
            }
            .navigationTitle("Editar Alumno")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch { errorMensaje = error.localizedDescription }
                    }.disabled(!datosCompletos)
                }
            }
            // @Bindable edita el modelo directamente; como en el PDF, no hay Cancelar.
            // Evitar cierre interactivo para que Listo confirme el guardado explícito.
            .interactiveDismissDisabled()
            .alert("No se pudo guardar", isPresented: Binding(get: { errorMensaje != nil },
                                                             set: { if !$0 { errorMensaje = nil } })) {
                Button("Aceptar", role: .cancel) { errorMensaje = nil }
            } message: { Text(errorMensaje ?? "") }
        }
    }
}
