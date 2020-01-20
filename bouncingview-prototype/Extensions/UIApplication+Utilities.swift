//
//  UIApplication+Utilities.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit.UIApplication

public extension UIApplication {

    /// Gets the safe area insets if available.
    static var safeAreaInsets: UIEdgeInsets {
        if let safeAreaInsets = shared.keyWindow?.safeAreaInsets {
            return safeAreaInsets
        }
        return .zero
    }
}
