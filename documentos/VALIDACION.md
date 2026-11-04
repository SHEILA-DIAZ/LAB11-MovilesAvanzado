# Validación del Laboratorio 11

Fecha: 4 de noviembre de 2026. Rama de trabajo: `ia-asistida`.

## Fuente y alcance

Se encontró el PDF exacto `GLAB-S11-JLEONS-2026-02.pdf` en Descargas y se incorporó a `documentos/`, pues el repositorio inicialmente solo contenía README.md. Se extrajo el texto de sus 30 páginas y se revisaron las instrucciones de las actividades 01 y 02 (páginas 3–19), incluida revisión visual de la página 11. Solo se implementaron esas dos actividades, en orden. No se desarrolló Parte 3 ni el trabajo de la semana.

## Entorno real

- macOS con Xcode 26.3, build 17C529.
- SDK iPhoneSimulator 26.2; runtime instalado iOS 26.3.
- iPhone 17 Pro, UUID `859B6D6D-3B87-4D12-8A66-1683D3BCD024`.
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` por comando; la selección global quedó en Command Line Tools.
- XcodeGen 2.46.0 para generar los dos proyectos y sus esquemas compartidos. Los `.xcodeproj` completos están en Git; no hace falta XcodeGen para abrirlos.
- Compilación para simulador sin firma; no se probó en dispositivo físico ni en iPad.

## Resultados ejecutados

| Proyecto | Validación | Resultado |
| --- | --- | --- |
| Parte 1 | Build inicial Storyboard y NSPersistentContainer, después de corregir dataMode del prototipo | BUILD SUCCEEDED |
| Parte 1 | Build del modelo Contacto y CRUD ordenado | BUILD SUCCEEDED |
| Parte 1 final | `ContactoTests.testSQLiteCRUDOrdenBusquedaRelacionYNullify` | Pasó, 0.060 s |
| Parte 1 final | `ContactoUITests.testCRUDPersistenciaBusquedaYGrupo` | Pasó, 47.655 s |
| Parte 1 final | Compilación y ejecución de ambos targets en simulador | TEST SUCCEEDED, 2 pruebas, 0 fallos |
| Parte 2 | Build del modelo @Model y ModelContainerProvider | BUILD SUCCEEDED |
| Parte 2 | Build de registro, listado y eliminación | BUILD SUCCEEDED |
| Parte 2 final | `AlumnoTests.testSQLiteCRUDRelacionPersistenciaYNullify` | Pasó, 0.129 s |
| Parte 2 final | `AlumnoUITests.testCRUDPersistenciaBusquedaFiltradaYCurso` | Pasó, 63.914 s |
| Parte 2 final | Compilación y ejecución de ambos targets en simulador | TEST SUCCEEDED, 2 pruebas, 0 fallos |

Los dos comandos finales de `xcodebuild test` utilizaron `-destination 'platform=iOS Simulator,id=859B6D6D-3B87-4D12-8A66-1683D3BCD024'`, sus proyectos/esquemas respectivos y DerivedData local. Los comandos reproducibles están en README.md.

Resultados locales, excluidos de Git:

- `.build/P1-tests-final.xcresult`: ejecución final aprobada de Contacto.
- `.build/P2-tests.xcresult`: ejecución aprobada de Alumno.
- `.build/P1-tests.xcresult`: primera ejecución de Contacto; conserva el fallo de automatización corregido.

## Cobertura de persistencia

**Contacto, prueba SQLite:** inserta tres contactos en disco, comprueba orden alfabético, filtro `CONTAINS[cd]` (Juan encuentra Juán), filtro por `grupo.nombre`, relación inversa de tres contactos, modificación de teléfono leída desde otro contenedor, Nullify al borrar el grupo y eliminación confirmada con una nueva lectura del archivo.

**Contacto, interfaz:** registro mediante alerta, relanzamiento sin borrar datos, edición tocando la fila, búsqueda, demostración de Amigos y filtro por grupo, relanzamiento con edición persistida, swipe para eliminar y otro relanzamiento para comprobar la ausencia.

**Alumno, prueba SQLite:** inserta tres alumnos con Curso, verifica la inversa y orden, edita nombre, libera y reabre el contenedor para leer los datos y la relación desde disco, filtra por apellido sin distinguir mayúsculas, elimina el resultado filtrado, borra el curso y reabre para verificar que los alumnos restantes están sin curso (Nullify).

**Alumno, interfaz:** botón Guardar desactivado con campos vacíos; registra dos alumnos; relanza para comprobar ambos; pulsa dos veces Curso demo; verifica el curso en detalle; edita apellido con @Bindable y Listo; relanza y comprueba apellido y curso; busca el apellido editado; elimina desde la lista filtrada; relanza y verifica que desapareció solo el alumno elegido y que el otro mantiene su curso. Finalmente elimina el segundo registro creado por esa prueba.

Las pruebas de interfaz usan nombres/identificadores aleatorios y no restablecen el almacén para fingir persistencia. La primera ejecución fallida de Contacto dejó un registro de prueba en el simulador; se conservó sin borrar datos ajenos.

## Incidencias corregidas y límites

1. El Storyboard escrito inicialmente no declaraba `dataMode="prototypes"`; ibtool lo detectó y se corrigió antes del primer commit.
2. La preparación inicial de la prueba Core Data cargaba otra copia del modelo y eliminaba el archivo temporal antes de cerrar los stores. Se cambió a reutilizar el modelo de AppDelegate y quitar los almacenes antes de limpiar. La ejecución final pasó sin esos errores.
3. La primera prueba de interfaz de Contacto esperaba el botón de búsqueda Cancel; iOS 26 expone Close. Se adaptó la automatización a ambos y la ejecución final pasó.
4. Xcode emite el aviso de extracción de metadatos AppIntents al no existir dependencia de ese framework; no afecta las actividades.
5. La consola global apunta a Command Line Tools. Un intento fallido de pruebas mostró además un fallo de recogida de diagnósticos de simctl por esa selección. Los comandos de compilación y pruebas usaron DEVELOPER_DIR explícito; las ejecuciones finales se completaron.
6. No se ha validado migración desde una versión antigua instalada por otra aplicación ni recuperación de un SQLite corrupto. No se elimina ni reinicia la base automáticamente ante errores.

## Correcciones técnicas al PDF

Se conservaron nombres, atributos, APIs, arquitectura y pantallas de cada actividad. En UIKit se expuso la búsqueda y la demostración de Grupo en la pantalla existente para probarlas sin editar código temporalmente. Se evita crear Amigos sin contactos o repetirlo. En SwiftData se crea Application Support antes de abrir SQLite y se llama save() explícito al editar, eliminar y asignar Curso. La lista de objetos a eliminar se captura desde los resultados filtrados antes de modificar el contexto. Los fallos de guardado se muestran al usuario; un nuevo alumno no cierra el formulario si falla. @Bindable modifica directamente el objeto como en el PDF; Listo confirma la edición y no se ofrece Cancelar. Curso demo reutiliza el curso para no duplicarlo al pulsarlo varias veces.

## Git y publicación

Se crearon commits progresivos reales con las etapas compiladas: base UIKit; modelo y CRUD Contacto; búsqueda, Grupo y pruebas; base SwiftData con Alumno y contenedor; registro/listado/eliminación; edición, búsqueda, Curso y pruebas. Consultar `git log --oneline ia-asistida` para el historial publicado.

Se ejecutó `git push origin ia-asistida` tras las etapas. GitHub rechazó los push con **HTTP 403**, indicando `Permission to SHEILA-DIAZ/LAB11-MovilesAvanzado.git denied to Jamestecsup`. En ese momento las credenciales correspondían a Jamestecsup, sin permiso de escritura. Esta incidencia se resolvió posteriormente autenticando a SHEILA-DIAZ y publicando los seis commits.

Por instrucción posterior de la propietaria se corrigieron autor y committer del commit inicial, preservando todos los demás metadatos y los árboles de ambas ramas. El nuevo commit inicial es d427f69; las ramas main e ia-asistida se publicaron con leases explícitos y actualización atómica, y se verificaron mediante la API de GitHub. No hay funcionalidades pendientes dentro de las actividades 01 y 02. La auditoría ampliada, con la matriz completa de requisitos y nuevos resultados, está en AUDITORIA.md.
