# Laboratorio 11 · Programación en Móviles Avanzado · Tecsup

Implementación exclusiva de **Parte 1 · Actividad 01 (Contacto)** y **Parte 2 · Actividad 02 (Alumno)**, siguiendo `documentos/GLAB-S11-JLEONS-2026-02.pdf` (páginas 3–19), en la rama `ia-asistida`.

## Proyectos independientes

```text
LAB11-MovilesAvanzado/
├── documentos/GLAB-S11-JLEONS-2026-02.pdf
├── apple_lab11_01_UIKit_CoreData/
│   ├── apple_lab11_01_UIKit_CoreData.xcodeproj
│   ├── project.yml
│   ├── Sources/
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj/Main.storyboard
│   │   ├── ViewController.swift
│   │   ├── ViewController+Relacion.swift
│   │   └── apple_lab11_01_UIKit_CoreData.xcdatamodeld/
│   ├── Tests/ContactoTests.swift
│   ├── UITests/ContactoUITests.swift
│   └── README.md
└── apple_lab11_02_SwiftUI_SwiftData/
    ├── apple_lab11_02_SwiftUI_SwiftData.xcodeproj
    ├── project.yml
    ├── Sources/
    │   ├── apple_lab11_02_SwiftUI_SwiftDataApp.swift
    │   ├── Alumno.swift
    │   ├── Curso.swift
    │   ├── ModelContainerProvider.swift
    │   ├── ContentView.swift
    │   ├── NuevoAlumnoView.swift
    │   └── EditarAlumnoView.swift
    ├── Tests/AlumnoTests.swift
    ├── UITests/AlumnoUITests.swift
    └── README.md
```

Abrir cada `.xcodeproj` por separado en Xcode. Requieren iOS 17 o posterior. Los proyectos, esquemas y modelos están incluidos y no dependen de paquetes externos. XcodeGen 2.46.0 se utilizó para generar los proyectos; solo hace falta si se desea regenerarlos desde `project.yml`.

## Funcionalidades

| Actividad | Implementación |
| --- | --- |
| Contacto (UIKit + Core Data) | Storyboard con Navigation Controller, tabla Subtitle y botón +; modelo Contacto con nombre, telefono y direccion; NSPersistentContainer; CRUD con alertas y swipe; NSFetchRequest ordenada por nombre y búsqueda `CONTAINS[cd]`; Grupo.contactos ↔ Contacto.grupo, inversa y Nullify; demostración Amigos y filtro por relación. |
| Alumno (SwiftUI + SwiftData) | Modelo @Model con UUID, apellido, nombre y dni; ModelContainerProvider singleton y SQLite; formulario, @Query ordenada por apellido, NavigationSplitView con detalle; edición @Bindable, borrado y búsqueda por apellido; Curso.alumnos ↔ Alumno.curso con Nullify; demostración Curso. |

Cada aplicación imprime la ruta de su SQLite en consola. Ambas guardan en disco, sin precargar datos. Los previews de SwiftUI usan memoria. Los README de cada proyecto explican los controles y las correcciones técnicas aplicadas a los ejemplos del PDF.

## Compilar y probar

Entorno utilizado: Xcode 26.3 (17C529), SDK iOS Simulator 26.2, runtime iOS 26.3, iPhone 17 Pro. La selección global de la terminal apuntaba a Command Line Tools; se usó `DEVELOPER_DIR` por comando, sin modificarla.

Desde la raíz del repositorio:

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -project apple_lab11_01_UIKit_CoreData/apple_lab11_01_UIKit_CoreData.xcodeproj -scheme apple_lab11_01_UIKit_CoreData -sdk iphonesimulator -derivedDataPath .build/P1 build
xcodebuild -project apple_lab11_02_SwiftUI_SwiftData/apple_lab11_02_SwiftUI_SwiftData.xcodeproj -scheme apple_lab11_02_SwiftUI_SwiftData -sdk iphonesimulator -derivedDataPath .build/P2 build
xcodebuild -project apple_lab11_01_UIKit_CoreData/apple_lab11_01_UIKit_CoreData.xcodeproj -scheme apple_lab11_01_UIKit_CoreData -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath .build/P1 test
xcodebuild -project apple_lab11_02_SwiftUI_SwiftData/apple_lab11_02_SwiftUI_SwiftData.xcodeproj -scheme apple_lab11_02_SwiftUI_SwiftData -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath .build/P2 test
```

La firma está desactivada para las compilaciones del simulador. Para un dispositivo físico se debe configurar la firma y el equipo en Xcode.

La revisión paso a paso de los 23 pasos de la guía está en [documentos/AUDITORIA.md](documentos/AUDITORIA.md). El informe de ejecución inicial e incidencias está en `documentos/VALIDACION.md`. Los resultados `.xcresult` se conservan localmente en `.build/`, excluido de Git.

No se implementaron Parte 3, trabajo de la semana, Ventas, Compras, login, usuarios ni roles. El contenido de `main` permanece igual; su historial se actualizó únicamente para corregir la autoría inicial, por instrucción de la propietaria.
