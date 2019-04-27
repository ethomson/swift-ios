//  BeastMatch
//
//  Copyright © 2019 Edward Thomson. All rights reserved.

import UIKit

class ViewController: UIViewController {
    let buttonNames = [String](arrayLiteral:
        "Tile: Bear", "Tile: Bunny", "Tile: Cat", "Tile: Cow", "Tile: Dog",
                      "Tile: Fox", "Tile: Frog", "Tile: Hamster", "Tile: Koala", "Tile: Lion",
                      "Tile: Mouse", "Tile: Panda", "Tile: Pig", "Tile: Tiger")

    lazy var tiles = [Tile?]()
    lazy var matches = [Tile?]()
    var firstTile:Tile? = nil

    override func viewDidLoad() {
        let paddingX = 15
        let paddingY = 15

        let cols = 4
        let rows = 6

        let buttonSize = view.frame.width > 650 ? 150 : 75

        let startX = (Int(self.view.frame.width) - (buttonSize * cols) - (paddingX * (cols - 1))) / 2;
        let startY = (Int(self.view.frame.height) - (buttonSize * rows) - (paddingY * (rows - 1))) / 2;

        self.tiles = [Tile?](repeating: nil, count: rows * cols)

        super.viewDidLoad()

        for row in 0...(rows - 1) {
            for col in 0...(cols - 1) {
                let idx = (row * cols) + col

                let x = startX + col * (buttonSize + paddingX)
                let y = startY + row * (buttonSize + paddingY)

                self.tiles[idx] = Tile()
                self.tiles[idx]!.accessibilityIdentifier = String(idx)
                self.tiles[idx]!.frame = CGRect(x: x, y: y, width: buttonSize, height: buttonSize)
                self.tiles[idx]!.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
                self.view.addSubview(tiles[idx]!)
            }
        }

        self.setupTiles()
    }

    func resetTiles() {
        self.matches.removeAll()
        self.firstTile = nil

        for tile in self.tiles {
            tile!.hide()
        }
    }

    func setupTiles() {
        // Set up a consistent ordering of the critters
        for i in 0...((self.tiles.count / 2) - 1) {
            self.tiles[i]!.name = self.buttonNames[i]
            self.tiles[(tiles.count / 2) + i]!.name = self.buttonNames[i]
        }

        // Then shuffle
        self.shuffleTiles(tiles: self.tiles)
    }

    func shuffleTiles(tiles: [Tile?]) {
        for i in 0...(tiles.count - 1) {
            let swap = Int.random(in: 0...(tiles.count - 1))

            let name = tiles[i]!.name
            tiles[i]!.name = tiles[swap]!.name
            tiles[swap]!.name = name
        }
    }

    @objc func buttonPressed(sender: Tile!) {
        var completion:((Bool) -> ())? = nil

        if (sender.isVisible) {
            return
        } else if (self.firstTile == nil) {
            self.firstTile = sender
        } else {
            let one = self.firstTile
            self.firstTile = nil

            self.disableButtons()

            completion = { (finished: Bool) -> () in
                self.checkForMatch(one: one, two: sender)
                self.checkForWin()
            }
        }

        sender.show(completion: completion)
    }

    func checkForMatch(one: Tile!, two: Tile!) {
        if (one.name == two.name) {
            self.matches.append(one)
            self.matches.append(two)

            self.enableButtons()
            return
        }

        Thread.sleep(forTimeInterval: 1.0)
        self.enableButtons()

        one.hide()
        two.hide()
    }

    func disableButtons() {
        self.view.isUserInteractionEnabled = false
    }

    func enableButtons() {
        self.view.isUserInteractionEnabled = true
    }

    func checkForWin() {
        if (self.tiles.count != self.matches.count) {
            return
        }

        let winAlert = UIAlertController(title: "You win!",
                                         message: "Congratulations.  Would you like to play again?",
                                         preferredStyle: UIAlertController.Style.alert)
        winAlert.addAction(UIAlertAction(title: "Yes",
                                         style: .default,
                                         handler: { (action: UIAlertAction!) in self.resetTiles() }))
        present(winAlert, animated: true, completion: nil)
    }
}
