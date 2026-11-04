import XCTest

final class AlumnoUITests: XCTestCase {
    @MainActor
    func testCRUDPersistenciaBusquedaFiltradaYCurso() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let token = String(UUID().uuidString.prefix(5))
        let dni = String(Int.random(in: 10000000...49999999))
        let otroDni = String(Int.random(in: 50000000...99999999))
        let apellido = "Garcia\(token)"
        let editado = "Garrido\(token)"
        func captura(_ nombre: String) {
            let adjunto = XCTAttachment(screenshot: app.screenshot())
            adjunto.name = nombre
            adjunto.lifetime = .keepAlways
            add(adjunto)
        }
        app.buttons["nuevoAlumno"].tap()
        XCTAssertTrue(app.buttons["guardarAlumno"].waitForExistence(timeout: 5))
        app.textFields["apellido"].tap()
        app.textFields["apellido"].typeText("Cancelado\(token)")
        XCTAssertFalse(app.buttons["guardarAlumno"].isEnabled)
        captura("P2-formulario-validacion")
        app.buttons["Cancelar"].tap()
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Cancelado\(token)")).firstMatch.exists)
        func fila(_ documento: String) -> XCUIElement {
            app.descendants(matching: .any).matching(identifier: "alumno-\(documento)").firstMatch
        }
        func registrar(_ apellido: String, _ documento: String) {
            app.buttons["nuevoAlumno"].tap()
            XCTAssertTrue(app.buttons["guardarAlumno"].waitForExistence(timeout: 5))
            XCTAssertFalse(app.buttons["guardarAlumno"].isEnabled)
            app.textFields["apellido"].tap()
            app.textFields["apellido"].typeText(apellido)
            app.textFields["nombre"].tap()
            app.textFields["nombre"].typeText("Ana")
            XCTAssertFalse(app.buttons["guardarAlumno"].isEnabled)
            app.textFields["dni"].tap()
            app.textFields["dni"].typeText(documento)
            app.buttons["guardarAlumno"].tap()
            XCTAssertTrue(fila(documento).waitForExistence(timeout: 5))
        }
        registrar(apellido, dni)
        registrar("Torres\(token)", otroDni)
        app.terminate()
        app.launch()
        XCTAssertTrue(fila(dni).waitForExistence(timeout: 5))
        XCTAssertTrue(fila(otroDni).exists)
        captura("P2-listado-persistente")
        app.buttons["asignarCurso"].tap()
        app.buttons["asignarCurso"].tap()
        fila(dni).tap()
        XCTAssertTrue(app.staticTexts["Curso: Programación en Móviles"].waitForExistence(timeout: 5))
        app.buttons["editarAlumno"].tap()
        let campo = app.textFields["apellido"]
        XCTAssertTrue(campo.waitForExistence(timeout: 5))
        campo.tap()
        campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: apellido.count) + editado)
        let nombreCampo = app.textFields["nombre"]
        nombreCampo.tap()
        nombreCampo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 3) + "Sheila")
        let dniCampo = app.textFields["dni"]
        dniCampo.tap()
        dniCampo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: dni.count) + "12345678")
        captura("P2-editar-alumno")
        app.buttons["Listo"].tap()
        XCTAssertTrue(app.staticTexts["Apellido: \(editado)"].waitForExistence(timeout: 5))
        app.terminate()
        app.launch()
        XCTAssertTrue(fila("12345678").waitForExistence(timeout: 5))
        fila("12345678").tap()
        XCTAssertTrue(app.staticTexts["Apellido: \(editado)"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Curso: Programación en Móviles"].exists)
        XCTAssertTrue(app.staticTexts["Nombre: Sheila"].exists)
        XCTAssertTrue(app.staticTexts["DNI: 12345678"].exists)
        captura("P2-detalle-persistente")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let search = app.searchFields.firstMatch
        if !search.exists { app.swipeDown() }
        search.tap()
        search.typeText(editado.uppercased())
        XCTAssertTrue(fila("12345678").waitForExistence(timeout: 5))
        XCTAssertFalse(fila(otroDni).exists)
        captura("P2-busqueda-por-apellido")
        fila("12345678").swipeLeft()
        app.buttons["Delete"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(fila(otroDni).waitForExistence(timeout: 5))
        XCTAssertFalse(fila("12345678").exists)
        fila(otroDni).tap()
        XCTAssertTrue(app.staticTexts["Curso: Programación en Móviles"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        fila(otroDni).swipeLeft()
        app.buttons["Delete"].tap()
    }
}
