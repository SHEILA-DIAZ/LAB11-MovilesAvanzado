# Parte 2 · Actividad 02 · Alumno

Abrir `apple_lab11_02_SwiftUI_SwiftData.xcodeproj` y ejecutar su esquema (iOS 17 o posterior). No necesita paquetes externos; el proyecto generado está incluido. `project.yml` es la especificación opcional para XcodeGen.

- `Alumno.swift`: `@Model` con `idAlumno: UUID`, apellido, nombre, dni y curso opcional.
- `ModelContainerProvider.swift`: singleton `@MainActor`, esquema Alumno y Curso y almacén persistente `Application Support/AlumnosData.sqlite`; imprime la ruta al arrancar.
- `apple_lab11_02_SwiftUI_SwiftDataApp.swift`: inyecta el contenedor con `.modelContainer`.
- `NuevoAlumnoView.swift`: formulario con validación de campos vacíos y guardado explícito; Cancelar no inserta datos.
- `ContentView.swift`: `NavigationSplitView`, `@Query` ordenada por apellido, detalle, eliminación con swipe o Edit, `.searchable` por apellido y hoja de edición.
- `EditarAlumnoView.swift`: campos enlazados al modelo mediante `@Bindable`; Listo confirma `save()`.
- `Curso.swift`: `@Relationship(deleteRule: .nullify, inverse: \Alumno.curso)`; un curso tiene muchos alumnos.

Para la relación: registrar al menos dos alumnos y pulsar el libro **Curso demo**. Al abrir cada detalle debe aparecer **Curso: Programación en Móviles**. Repetir la acción reutiliza el mismo curso; no crea duplicados. Los alumnos registrados después quedan Sin curso hasta volver a pulsar el libro, tal como en el ejemplo.

Para persistencia: registrar, detener y ejecutar; editar y repetir; asignar el curso y repetir; borrar y repetir. No desinstalar la app para esta comprobación. La consola imprime la ruta SQLite.

Las pruebas verifican CRUD sobre SQLite en disco con reapertura del contenedor, orden, filtro por apellido, relación inversa y Nullify. La prueba de interfaz registra dos alumnos, valida campos vacíos, usa @Bindable, asigna Curso, relanza y elimina con búsqueda activa comprobando que se conserva el otro alumno.

Correcciones técnicas respecto del ejemplo: crear Application Support antes de abrir SQLite; guardar explícitamente al eliminar, editar y asignar curso; mantener abierto el formulario y mostrar un error si falla el guardado; capturar los objetos filtrados antes de borrarlos; reutilizar el curso. La edición usa el enlace directo del PDF, por lo que no tiene Cancelar; el cierre interactivo se bloquea para pasar por Listo. La plantilla Item se reemplazó directamente junto con ContentView, sin referencias residuales.
