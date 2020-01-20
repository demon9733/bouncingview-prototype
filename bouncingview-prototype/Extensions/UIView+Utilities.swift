//
//  UIView+Utilities.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {

    func addSubview(_ view: UIView, makeConstraints: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints { makeConstraints($0) }
    }

    //

    func addBottomBorder() {
        _ = UIView().then { v in
            v.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)

            addSubview(v) { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.borderWidth)
            }
        }
    }

    func addTopBorder() {
        _ = UIView().then { v in
            v.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)

            addSubview(v) { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(CGFloat.borderWidth)
            }
        }
    }
}

private extension CGFloat {

    static var borderWidth: Self {
        switch UIScreen.main.scale {
        case 3: return 2 / UIScreen.main.scale
        default: return 1 / UIScreen.main.scale
        }
    }
}
