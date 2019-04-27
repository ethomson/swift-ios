//  BeastMatch
//
//  Copyright © 2019 Edward Thomson. All rights reserved.

import XCTest

class BeastMatchUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-noanimation"]
        app.launch()
    }

    override func tearDown() {
    }

    func testDoubleTapOnTileIsIgnored() {
        XCTAssert(app.buttons["0"].label == "Hidden")

        app.buttons["0"].tap()
        XCTAssert(app.buttons["0"].label != "Hidden")

        app.buttons["0"].tap()
        XCTAssert(app.buttons["0"].label != "Hidden")
    }

    func testTapOnVisibleTileIsIgnored() {
        testSelectMatchingTiles()
        XCTAssert(app.buttons["0"].label != "Hidden")

        app.buttons["0"].tap()
        app.buttons["0"].tap()
        XCTAssert(app.buttons["0"].label != "Hidden")
    }

    func testSelectMatchingTiles() {
        for idx in (1...23) {
            XCTAssert(app.buttons["0"].label == "Hidden")

            app.buttons["0"].tap()
            XCTAssert(app.buttons["0"].label != "Hidden")

            let button = app.buttons[String(idx)]
            button.tap()

            if (button.label != "Hidden") {
                XCTAssert(button.label == app.buttons["0"].label)
                return
            }
        }

        XCTFail("no matching tile")
    }

    func testWin() {
        for a in (0...22) {
            for b in (a+1...23) {
                let buttonA = app.buttons[String(a)]
                let buttonB = app.buttons[String(b)]

                if (buttonA.label != "Hidden" || buttonB.label != "Hidden") {
                    continue
                }

                buttonA.tap()
                buttonB.tap()

                if (buttonA.label != "Hidden" && buttonB.label != "Hidden") {
                    break
                }
            }
        }

        XCTAssertEqual(app.alerts.element.label, "You win!")
    }
}
