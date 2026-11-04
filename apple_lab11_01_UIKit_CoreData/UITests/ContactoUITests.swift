import XCTest

final class ContactoUITests: XCTestCase {
    @MainActor
    func testCRUDPersistenciaBusquedaYGrupo() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let token = String(UUID().uuidString.prefix(6))
        let nombre = "Ana\(token)"
        let editado = "Juan\(token)"
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
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tables.staticTexts[nombre].waitForExistence(timeout: 5))
        app.tables.staticTexts[nombre].tap()
        let editar = app.alerts["Editar Contacto"]
        let campo = editar.textFields["Nombre"]
        campo.tap()
        campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: nombre.count) + editado)
        editar.buttons["Guardar"].tap()
        let search = app.searchFields.firstMatch
        search.tap()
        search.typeText(editado)
        XCTAssertTrue(app.tables.staticTexts[editado].waitForExistence(timeout: 5))
        XCTAssertEqual(app.tables.cells.count, 1)
        // Desactivar la búsqueda permite acceder a la barra de navegación.
        let cerrar = app.buttons["Close"]
        if cerrar.exists { cerrar.tap() } else { app.buttons["Cancel"].tap() }
        app.buttons["grupoDemo"].tap()
        app.buttons["filtroGrupo"].tap()
        XCTAssertGreaterThan(app.tables.cells.count, 0)
        XCTAssertTrue(app.tables.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Amigos")).firstMatch.exists)
        app.buttons["filtroGrupo"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tables.staticTexts[editado].waitForExistence(timeout: 5))
        let cell = app.tables.cells.containing(.staticText, identifier: editado).firstMatch
        cell.swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.tables.staticTexts[editado].exists)
        app.terminate()
        app.launch()
        XCTAssertFalse(app.tables.staticTexts[editado].waitForExistence(timeout: 2))
    }
}
