//
//  MainViewController.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var containerView: UIView!
    var hideButton: UIView!

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

