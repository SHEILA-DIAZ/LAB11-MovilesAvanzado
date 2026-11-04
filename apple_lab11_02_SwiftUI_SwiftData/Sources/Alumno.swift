import Foundation
import SwiftData

@Model
class Alumno {
    var idAlumno: UUID
    var apellido: String
    var nombre: String
    var dni: String
    var curso: Curso?

    init(idAlumno: UUID = UUID(), apellido: String, nombre: String, dni: String) {
        self.idAlumno = idAlumno
        self.apellido = apellido
        self.nombre = nombre
        self.dni = dni
    }
}
