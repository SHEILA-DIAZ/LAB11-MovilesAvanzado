# Auditoría detallada de actividades 01 y 02

Fecha: 4 de noviembre de 2026. Fuente principal: `GLAB-S11-JLEONS-2026-02.pdf`, páginas 3–19. Se revisó el texto completo de los pasos de ambas actividades y las figuras de las páginas 5 y 16. Alcance: dos proyectos independientes; ninguna funcionalidad de Parte 3 o del trabajo de la semana.

## Parte 1: Actividad 01 — Contacto

| Paso | Requisito de la guía | Evidencia en el proyecto UIKit | Revisión |
| --- | --- | --- | --- |
| 1 | Proyecto apple_lab11_01_UIKit_CoreData, Swift, Storyboard y Core Data | `.xcodeproj`, `project.yml`, `Sources/Base.lproj/Main.storyboard`, `AppDelegate.swift` y modelo `.xcdatamodeld` | Conforme |
| 2 | Entidad Contacto; nombre, telefono y direccion de tipo String opcional; Class Definition | Modelo XML con las tres propiedades y `codeGenerationType="class"`; sin clases manuales duplicadas | Conforme |
| 3 | NSPersistentContainer con el nombre del modelo; loadPersistentStores y viewContext | `AppDelegate.persistentContainer`; SQLite en disco, sin configuración de memoria para la app | Conforme |
| 4 | Navigation Controller, tabla con constraints, celda Subtitle Cell, título, +, TablaContacto y agregarContacto | Storyboard: segue raíz, cuatro constraints, estilo Subtitle, identificador Cell y conexiones outlet/action correctas | Conforme |
| 5 | Contexto, delegate/dataSource y ruta SQLite | `ViewController.conexion`, `viewDidLoad`, `mostrarRutaBaseDeDatos` | Conforme |
| 6 | Leer con NSFetchRequest y orden por nombre; mostrar nombre, teléfono y dirección | `consultarContactos`, `cargarInfoCoreData` y `cellForRowAt`; fetch real y reloadData | Conforme |
| 7 | Crear mediante alerta de tres campos, validar nombre y guardar; registrar al menos tres | `presentarFormulario(contacto: nil)`; NSEntityDescription, save y recarga; prueba de interfaz con tres registros | Conforme |
| 8 | Detener y ejecutar conservando datos; ruta SQLite | Pruebas con terminate/launch sin borrar la app; prueba de SQLite con contenedores independientes | Conforme |
| 9 | Tocar fila, editar datos existentes, guardar y conservar cambios tras reiniciar | `didSelectRowAt`, formulario precargado y save; prueba ampliada cambia los tres campos y comprueba Cancelar | Conforme |
| 10 | Eliminar con swipe, guardar y comprobar que no reaparece | `commit editingStyle`, `eliminarContacto`, save y deleteRows; relanzamiento en prueba UI | Conforme |
| 11 | ViewController+Relacion.swift, buscarContactos con CONTAINS[cd] y orden | Función del mismo nombre delega en el fetch compartido con predicate; UISearchController permite probarla desde la pantalla | Conforme, adaptación técnica documentada |
| 12 | Grupo.nombre, contactos To Many, grupo To One, inversas y Nullify; demo Amigos y consulta grupo.nombre | Modelo verificado estructuralmente; `probarRelacion`, `contactosDelGrupo` y filtro combinable | Conforme, demo voluntaria sin duplicados |

Las pruebas unitarias ejecutan también las funciones reales del controlador para verificar búsqueda sin tildes ni distinción de mayúsculas, orden, filtro compuesto, grupo sin duplicados y ausencia de grupos vacíos. La prueba de SQLite valida una relación de tres contactos y que Nullify no los borre al eliminar el grupo.

## Parte 2: Actividad 02 — Alumno

| Paso | Requisito de la guía | Evidencia en el proyecto SwiftUI | Revisión |
| --- | --- | --- | --- |
| 1 | Proyecto apple_lab11_02_SwiftUI_SwiftData, SwiftUI y SwiftData | `.xcodeproj`, `project.yml` y entrada AlumnosApp | Conforme |
| 2 | Reconocer la plantilla Item y sustituirla sin referencias rotas | El estado final contiene solo Alumno y Curso; no quedan Item ni consultas del ejemplo de fechas | Conforme en el resultado final |
| 3 | Alumno @Model; idAlumno UUID, apellido, nombre, dni e inicializador | `Alumno.swift`, UUID generado por defecto y campos String | Conforme |
| 4 | ModelContainerProvider singleton @MainActor; esquema y archivo AlumnosData.sqlite | `ModelContainerProvider.swift`; directorio Application Support, ModelConfiguration y ModelContainer persistentes | Conforme |
| 5 | Inyectar el contenedor desde la App | `AlumnosApp` usa `.modelContainer(ModelContainerProvider.shared.container)` | Conforme |
| 6 | NuevoAlumnoView con @State, formulario, DNI numérico, insertar/guardar, validación y Cancelar | `NuevoAlumnoView.swift`; no cierra si falla save y no inserta al cancelar | Conforme |
| 7 | NavigationSplitView, List, @Query ordenada por apellido, selección y detalle, +, Edit y .onDelete | `ContentView.swift`; actualización automática, sin reloadData | Conforme |
| 8 | Reiniciar y conservar registros; imprimir ruta SQLite | Pruebas de interfaz con terminate/launch y prueba con reapertura del archivo; print en el proveedor | Conforme |
| 9 | EditarAlumnoView, @Bindable, campos enlazados, hoja y botón Listo | `EditarAlumnoView.swift` y `.sheet(item:)`; guardado explícito al confirmar | Conforme |
| 10 | .searchable por apellido sin distinguir mayúsculas; borrar usando los índices filtrados | `alumnosFiltrados`, `.searchable` sobre List y captura de objetos de esa lista en deleteAlumnos | Conforme |
| 11 | Curso @Model, alumnos To Many, curso opcional e inversa Nullify; esquema y Preview; libro asigna a todos | `Curso.swift`, `Alumno.curso`, esquema/Preview con ambos modelos, detalle y `asignarCursoDemo` | Conforme, demo reutiliza el curso |

La prueba de SQLite comprueba tres alumnos, orden, relación inversa, reapertura del contenedor, actualización, borrado desde resultados filtrados y Nullify. La prueba de interfaz comprueba validación del formulario y Cancelar, dos registros, edición de apellido/nombre/DNI con @Bindable, curso en ambos alumnos, búsqueda en mayúsculas, eliminación filtrada y persistencia tras relanzar.

## Equivalencias y ajustes técnicos

- Los proyectos se generaron con XcodeGen y se abren/compilan como proyectos nativos de Xcode. La guía describe su creación manual con el asistente; no se afirma que se hayan realizado esos clics. El resultado conserva los nombres, frameworks y artefactos exigidos.
- El Item temporal de la plantilla SwiftData se reemplazó directamente junto con ContentView. El resultado final exigido no contiene Item.
- Las funciones de búsqueda Core Data comparten una implementación para mantener los mismos filtros y orden. Se conserva la API `buscarContactos(texto:)` del PDF y se evita dejar la búsqueda fija de prueba en viewDidLoad.
- Grupo demo se ejecuta mediante un botón de la misma pantalla y reutiliza Amigos. Curso demo también reutiliza su curso. Esto evita los duplicados que la guía advierte al repetir las demostraciones.
- Se crea Application Support antes de abrir SQLite. Los guardados de edición, borrado y curso son explícitos, además del autosave de SwiftData.
- `.searchable` se aplica a List; el borrado toma una instantánea de `alumnosFiltrados` para que @Query no desplace los índices durante eliminaciones múltiples.
- La edición usa @Bindable directo como el PDF: los cambios se reflejan en el objeto mientras se escribe y pueden guardarse automáticamente. Listo añade save explícito; no se presenta como una transacción con Cancelar.
- La guía no exige DNI único, validación de ocho dígitos, obligatoriedad de teléfono/dirección, pantallas de mantenimiento de grupos/cursos ni iconos de Ventas/Compras en estas actividades. No se añadieron esas reglas o pantallas.

## Ejecución de la auditoría

Simulador exclusivo `Lab11 Auditoria`, iPhone 17 Pro con runtime iOS 26.3, UUID `121E180D-9E9A-4F51-93BD-1AEB039F4CB0`. Se creó para aislar las demostraciones de los datos del simulador habitual; durante las pruebas de persistencia se usa el mismo almacén entre relanzamientos, sin desinstalar ni borrar la app.

Los resultados y capturas se registran tras completar la ejecución, en la sección final de este informe. No se probaron dispositivos físicos ni se garantiza comportamiento en versiones de iOS distintas de la ejecutada. Las funciones y modelos se contrastaron con la API disponible en el SDK local de Xcode.

## Hallazgos y correcciones

1. **Título de Contacto no visible en la ejecución inicial.** Aunque el Storyboard contenía exactamente el título solicitado, las capturas mostraron una barra superior negra sin título visible. Se estableció fondo de sistema en la vista y apariencia de navegación de sistema, y se movió Grupo demo a la barra inferior para reservar espacio al título. El botón + se mantiene arriba a la derecha; no se añadieron pantallas. El filtro se localiza ahora por identificador en lugar de depender de su posición en la barra. La prueba de interfaz exige la existencia del título y se revisan las capturas finales.
2. **Evidencia de pruebas anterior incompleta.** La prueba UI de Contacto solo registraba un contacto y las de edición solo cambiaban un campo. Se ampliaron a tres contactos, comprobación de orden, cancelación de alta/edición, edición de todos los campos, búsqueda sin distinción de tildes/mayúsculas y limpieza de los registros propios. En Alumno se amplió la validación por campos faltantes, Cancelar y edición de apellido, nombre y DNI con posterior relanzamiento. Se añadió una prueba que ejecuta las consultas reales del controlador Core Data y la demostración sin duplicados.
3. **Informe inicial desactualizado.** VALIDACION.md aún describía el fallo 403 como pendiente. Se conservó la incidencia histórica y se documentó que quedó resuelta con la autenticación de SHEILA-DIAZ y la publicación, junto con la corrección posterior de autoría solicitada por la propietaria. No se modificó main durante esta auditoría.

Las diferencias visuales de los controles de sistema respecto de las figuras del PDF se deben a iOS 26 (botones, búsqueda inferior SwiftUI y hojas). Se conservan los controles, datos y operaciones requeridos.

## Resultado final ejecutado

Xcode 26.3 (17C529), SDK Simulator 26.2 y runtime iOS 26.3. Ambas aplicaciones compilaron como parte de sus comandos `xcodebuild test` y ambas ejecuciones terminaron con **TEST SUCCEEDED**.

| Prueba | Resultado | Duración |
| --- | --- | --- |
| ContactoTests.testConsultasDelControladorYDemoSinDuplicados | Aprobada | 0.239 s |
| ContactoTests.testSQLiteCRUDOrdenBusquedaRelacionYNullify | Aprobada | 0.066 s |
| ContactoUITests.testCRUDPersistenciaBusquedaYGrupo | Aprobada | 85.202 s |
| AlumnoTests.testSQLiteCRUDRelacionPersistenciaYNullify | Aprobada | 0.118 s |
| AlumnoUITests.testCRUDPersistenciaBusquedaFiltradaYCurso | Aprobada | 73.266 s |

**Total final: 5 pruebas, 0 fallos.** La primera ejecución ampliada de Contacto también aprobó sus tres pruebas, pero se repitió después de la corrección visual. No se cuentan ambas ejecuciones como pruebas diferentes.

Los bundles locales de evidencia son `.build/Auditoria-P1-final.xcresult` y `.build/Auditoria-P2.xcresult`; `.build/Auditoria-P1.xcresult` conserva la ejecución anterior al ajuste visual. Se excluyen de Git por tamaño. Las capturas se exportaron desde los adjuntos de XCTest, se inspeccionaron una por una y se guardaron sin edición en `capturas-auditoria/`:

- [Contacto: tres registros y título completo](capturas-auditoria/P1-tres-contactos.png).
- [Contacto: edición de los tres campos](capturas-auditoria/P1-editar-contacto.png).
- [Contacto: relación Amigos y filtro](capturas-auditoria/P1-relacion-Amigos.png).
- [Alumno: formulario incompleto y Guardar desactivado](capturas-auditoria/P2-formulario-validacion.png).
- [Alumno: listado persistente](capturas-auditoria/P2-listado-persistente.png).
- [Alumno: edición con @Bindable](capturas-auditoria/P2-editar-alumno.png).
- [Alumno: detalle con los tres campos editados y Curso tras relanzar](capturas-auditoria/P2-detalle-persistente.png).
- [Alumno: búsqueda por apellido en mayúsculas](capturas-auditoria/P2-busqueda-por-apellido.png).

Para reproducir las ejecuciones desde la raíz (requiere el simulador de auditoría creado en este equipo):

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -project apple_lab11_01_UIKit_CoreData/apple_lab11_01_UIKit_CoreData.xcodeproj -scheme apple_lab11_01_UIKit_CoreData -destination 'platform=iOS Simulator,id=121E180D-9E9A-4F51-93BD-1AEB039F4CB0' -parallel-testing-enabled NO -derivedDataPath .build/P1 test
xcodebuild -project apple_lab11_02_SwiftUI_SwiftData/apple_lab11_02_SwiftUI_SwiftData.xcodeproj -scheme apple_lab11_02_SwiftUI_SwiftData -destination 'platform=iOS Simulator,id=121E180D-9E9A-4F51-93BD-1AEB039F4CB0' -parallel-testing-enabled NO -derivedDataPath .build/P2 test
```

No quedan incumplimientos identificados de las actividades 01 y 02 tras esta revisión. El único cambio en código de la aplicación fue la presentación de la barra de Contacto y la localización de su botón de filtro; los modelos, los datos y el alcance permanecen iguales. Las pruebas y las capturas aportan evidencia de los comportamientos descritos; no constituyen una garantía sobre escenarios no ejecutados, como un dispositivo físico, una migración desde un almacén ajeno o almacenamiento corrupto.
