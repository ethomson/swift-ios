//  BeastMatch
//
//  Copyright © 2019 Edward Thomson. All rights reserved.

import XCTest
@testable import BeastMatch

class BeastMatchTests: XCTestCase {
    var viewController: ViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as? ViewController
    }

    override func tearDown() {
    }

    func testShuffleTiles() {
        var tiles = [Tile?](repeating: nil, count: 42)

        for idx in (0...41) {
            tiles[idx] = Tile()
            tiles[idx]!.name = String(idx)
        }

        XCTAssertTrue(isMonotonicallyIncreasing(tiles: tiles))
        viewController.shuffleTiles(tiles: tiles)
        XCTAssertFalse(isMonotonicallyIncreasing(tiles: tiles))
    }

    func isMonotonicallyIncreasing(tiles: [Tile?]) -> Bool {
        var i = 0

        for tile in tiles {
            if (tile!.name != String(i)) {
                return false
            }

            i = i + 1
        }

        return true
    }
}
