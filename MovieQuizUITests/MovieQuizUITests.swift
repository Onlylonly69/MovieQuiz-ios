import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    @MainActor
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        sleep(3)
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)
    }
    func testNoButton() {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10", "Начальный индекс не 1/10")
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "2/10", "Индекс не обновился после ответа")
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер не изменился")
    }
    
    func testGameFinish() {
        sleep(2)
        
        for i in 1...10 {
            app.buttons["No"].tap()
            print("Ответили на вопрос \(i)/10")
            sleep(2)
        }
        
        let alertTitle = app.staticTexts["Этот раунд окончен!"]
        let exists = alertTitle.waitForExistence(timeout: 10)
        
        if !exists {
            
            print("=== ДЕБАГ: Все элементы на экране ===")
            for element in app.staticTexts.allElementsBoundByIndex {
                print("Текст: '\(element.label)'")
            }
        }
        
        XCTAssertTrue(exists, "Заголовок алерта не появился")
        
        let alertButton = app.buttons["Сыграть ещё раз"]
        XCTAssertTrue(alertButton.waitForExistence(timeout: 5), "Кнопка алерта не появилась")
    }
    
    func testAlertDismiss() {
        sleep(2)
        
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alertButton = app.buttons["Сыграть ещё раз"]
        XCTAssertTrue(alertButton.waitForExistence(timeout: 10), "Кнопка алерта не появилась")
        alertButton.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let indexExists = indexLabel.waitForExistence(timeout: 5)
        
        if indexExists {
            print("Индекс найден: \(indexLabel.label)")
            XCTAssertEqual(indexLabel.label, "1/10", "Игра не перезапустилась")
        } else {
            print("Индекс не найден после перезапуска")
        }
    }
}
