import XCTest

final class ContactoUITests: XCTestCase {
    @MainActor
    func testCRUDPersistenciaBusquedaYGrupo() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.navigationBars.staticTexts["Lista de Contactos - Tecsup"].waitForExistence(timeout: 5))
        let token = String(UUID().uuidString.prefix(6))
        let nombre = "Ana\(token)"
        let editado = "Juán\(token)"
        func captura(_ nombre: String) {
            let adjunto = XCTAttachment(screenshot: app.screenshot())
            adjunto.name = nombre
            adjunto.lifetime = .keepAlways
            add(adjunto)
        }
        func registrar(_ nombre: String) {
            app.buttons["agregarContacto"].tap()
            let formulario = app.alerts["Agregar Contacto"]
            XCTAssertTrue(formulario.waitForExistence(timeout: 5))
            formulario.textFields["Nombre"].tap()
            formulario.textFields["Nombre"].typeText(nombre)
            formulario.textFields["Telefono"].tap()
            formulario.textFields["Telefono"].typeText("999123456")
            formulario.textFields["Direccion"].tap()
            formulario.textFields["Direccion"].typeText("Tecsup")
            formulario.buttons["Aceptar"].tap()
            XCTAssertTrue(app.tables.staticTexts[nombre].waitForExistence(timeout: 5))
        }
        app.buttons["agregarContacto"].tap()
        let cancelado = "Cancelado\(token)"
        app.alerts.textFields["Nombre"].tap()
        app.alerts.textFields["Nombre"].typeText(cancelado)
        app.alerts.buttons["Cancelar"].tap()
        XCTAssertFalse(app.tables.staticTexts[cancelado].exists)
        registrar("Zoe\(token)")
        registrar("Bruno\(token)")
        app.buttons["agregarContacto"].tap()
        let alert = app.alerts["Agregar Contacto"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.textFields["Nombre"].tap()
        alert.textFields["Nombre"].typeText(nombre)
        alert.textFields["Telefono"].tap()
        alert.textFields["Telefono"].typeText("999123456")
        alert.textFields["Direccion"].tap()
        alert.textFields["Direccion"].typeText("Tecsup")
        alert.buttons["Aceptar"].tap()
        XCTAssertTrue(app.tables.staticTexts[nombre].waitForExistence(timeout: 5))
        captura("P1-tres-contactos")
        let filtro = app.searchFields.firstMatch
        filtro.tap()
        filtro.typeText(token)
        XCTAssertEqual(app.tables.cells.count, 3)
        XCTAssertEqual((0..<3).map { app.tables.cells.element(boundBy: $0).staticTexts.firstMatch.label },
                       [nombre, "Bruno\(token)", "Zoe\(token)"])
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tables.staticTexts[nombre].waitForExistence(timeout: 5))
        app.tables.staticTexts[nombre].tap()
        app.alerts["Editar Contacto"].textFields["Nombre"].tap()
        app.alerts["Editar Contacto"].textFields["Nombre"].typeText("Cancelado")
        app.alerts["Editar Contacto"].buttons["Cancelar"].tap()
        XCTAssertTrue(app.tables.staticTexts[nombre].exists)
        app.tables.staticTexts[nombre].tap()
        let editar = app.alerts["Editar Contacto"]
        let campo = editar.textFields["Nombre"]
        campo.tap()
        campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: nombre.count) + editado)
        let telefono = editar.textFields["Telefono"]
        telefono.tap()
        telefono.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 9) + "111222333")
        let direccion = editar.textFields["Direccion"]
        direccion.tap()
        direccion.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 6) + "Lima")
        captura("P1-editar-contacto")
        editar.buttons["Guardar"].tap()
        let search = app.searchFields.firstMatch
        search.tap()
        search.typeText("JUAN\(token)")
        XCTAssertTrue(app.tables.staticTexts[editado].waitForExistence(timeout: 5))
        XCTAssertEqual(app.tables.cells.count, 1)
        // Desactivar la búsqueda permite acceder a la barra de navegación.
        let cerrar = app.buttons["Close"]
        if cerrar.exists { cerrar.tap() } else { app.buttons["Cancel"].tap() }
        app.buttons["grupoDemo"].tap()
        app.buttons["filtroGrupo"].tap()
        XCTAssertGreaterThan(app.tables.cells.count, 0)
        XCTAssertTrue(app.tables.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Amigos")).firstMatch.exists)
        captura("P1-relacion-Amigos")
        app.buttons["filtroGrupo"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tables.staticTexts[editado].waitForExistence(timeout: 5))
        let cell = app.tables.cells.containing(.staticText, identifier: editado).firstMatch
        XCTAssertTrue(cell.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "111222333 | Lima")).firstMatch.exists)
        cell.swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.tables.staticTexts[editado].exists)
        app.terminate()
        app.launch()
        XCTAssertFalse(app.tables.staticTexts[editado].waitForExistence(timeout: 2))
        for restante in ["Bruno\(token)", "Zoe\(token)"] {
            XCTAssertTrue(app.tables.staticTexts[restante].exists)
            app.tables.cells.containing(.staticText, identifier: restante).firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
        }
    }
}
