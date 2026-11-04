# Parte 1 · Actividad 01 · Contacto

Abrir `apple_lab11_01_UIKit_CoreData.xcodeproj` y ejecutar el esquema del mismo nombre (iOS 17 o posterior). El proyecto Xcode está incluido: no requiere instalar dependencias. `project.yml` permite regenerarlo opcionalmente con XcodeGen.

- `Main.storyboard`: Navigation Controller, tabla con constraints, celda Subtitle `Cell`, outlet `TablaContacto` y acción `agregarContacto`.
- `AppDelegate`: `NSPersistentContainer` cuyo nombre coincide con el modelo. Guarda SQLite en el contenedor privado de la app e imprime la ruta en consola.
- `Contacto`: `nombre`, `telefono`, `direccion` (String opcionales); clase generada por Core Data.
- `ViewController`: fetch ordenado por nombre, registro con +, edición tocando una fila, eliminación deslizando.
- `ViewController+Relacion`: búsqueda por nombre con `CONTAINS[cd]`, consulta por `grupo.nombre` y relación Grupo.contactos ↔ Contacto.grupo con Nullify.

Para probar la relación: registrar tres contactos; pulsar **Grupo demo** para asignar el primer contacto visible a Amigos. **Ver Amigos / Ver todos** alterna el filtro por relación; puede combinarse con búsqueda. Cada pulsación reutiliza Amigos para evitar duplicados. No se ejecuta automáticamente al iniciar.

Para comprobar persistencia: registrar, detener y ejecutar; editar, detener y ejecutar; eliminar, detener y ejecutar. El estado debe mantenerse en cada paso. La consola permite ubicar el SQLite; opcionalmente consultar `SELECT ZNOMBRE, ZTELEFONO FROM ZCONTACTO;` con sqlite3.

Las pruebas incluidas cubren SQLite en disco, orden, búsqueda sin tildes, inversa, Nullify y CRUD; la prueba de interfaz cubre formularios, búsqueda, grupo y relanzamientos. No borran el almacén de la app para simular persistencia.

Correcciones técnicas respecto del ejemplo: recargar la tabla tras cada fetch; mostrar errores y hacer rollback si falla un guardado; exponer la búsqueda y la demostración mediante controles de la misma pantalla; reutilizar el grupo. No se añadieron pantallas ni funcionalidades de otras partes.
