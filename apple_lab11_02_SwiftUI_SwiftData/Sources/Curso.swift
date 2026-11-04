import Foundation
import SwiftData

@Model
class Curso {
    var nombre: String
    @Relationship(deleteRule: .nullify, inverse: \Alumno.curso)
    var alumnos: [Alumno] = []

    init(nombre: String) { self.nombre = nombre }
}
