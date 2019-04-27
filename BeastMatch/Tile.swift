//  BeastMatch
//
//  Copyright © 2019 Edward Thomson. All rights reserved.

import UIKit

class Tile : UIButton {
    var cvstPosition:Double = 0

    var name:String? = nil
    var isVisible = false

    let hiddenLabel = "Hidden"
    let hiddenImage = UIImage(named: "back")

    init() {
        super.init(frame: .zero)
        reset()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }

    func reset() {
        self.accessibilityLabel = hiddenLabel
        self.setImage(hiddenImage, for: [])
        isVisible = false
    }

    func show(completion: ((Bool) -> Void)? = nil) {
        self.accessibilityLabel = name!
        self.isVisible = true

        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.setImage(UIImage(named: self.name!), for: [])
        }, completion: completion)
    }

    func hide(completion: ((Bool) -> Void)? = nil) {
        self.isVisible = false
        self.accessibilityLabel = hiddenLabel

        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.setImage(self.hiddenImage, for: [])
        }, completion: completion)
    }

    func pop(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            Thread.sleep(forTimeInterval: 0.09)
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
