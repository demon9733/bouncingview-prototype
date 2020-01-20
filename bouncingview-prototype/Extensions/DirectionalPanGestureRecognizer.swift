//
//  DirectionalPanGestureRecognizer.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {

    enum Direction {
        case vertical, horizontal
    }

    let direction: Direction

    init(direction: Direction, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard state == .began else { return }
        let vel = velocity(in: view)

        switch direction {
        case .horizontal where abs(vel.y) > abs(vel.x): state = .cancelled
        case .vertical where abs(vel.x) > abs(vel.y): state = .cancelled
        default: break
        }
    }
}
