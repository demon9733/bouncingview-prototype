//
//  MainViewController.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //
    // MARK: - Modes Management

    let cardAnimationDuration: TimeInterval = 0.6
    let handleAreaHeight: CGFloat = 60
    let handleAreaSwipeWidth: CGFloat = 120

    var previousState: State?
    var state = State.hidden {
        didSet {
            previousState = oldValue
            showCardButton.isEnabled = state == .hidden
        }
    }

    var runningAnimators = [UIViewPropertyAnimator]()
    var progressWhenInterrupted = [UIViewPropertyAnimator: CGFloat]()

    //
    // MARK: - UI References

    var cardViewController: CardViewController!
    var blurEffectView: UIVisualEffectView!

    private var showCardButton: UIButton!

    //
    // MARK: - View Lifecycle

    override func loadView() {

        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true

        title = "Demo"

        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white

        setupUI()
        setupCardViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateTransitionIfNeeded(state: .fullscreen, duration: 0)
        animateTransitionIfNeeded(state: .hidden, duration: 0)
    }

    private func setupUI() {

        let stackView = UIStackView().then { v in

            v.axis = .vertical
            v.alignment = .center
            v.distribution = .equalSpacing

            view.addSubview(v) { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(44 + UIApplication.safeAreaInsets.top + 20)
                make.bottom.equalToSuperview().inset(49 + UIApplication.safeAreaInsets.bottom + 20)
            }
        }

        for _ in 0 ..< 5 {

            _ = UIImageView().then { v in
                v.image = UIImage(named: "placeholderIcon")
                v.sizeToFit()
                stackView.addArrangedSubview(v)
            }
        }

        showCardButton = UIButton(type: .system).then { v in

            v.setTitle("Show the Card", for: .normal)
            v.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

            v.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)

            v.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(375)
            }

            stackView.insertArrangedSubview(v, at: 2)
        }
    }
}

private extension MainViewController {

    @objc func showButtonTapped() {
        animateTransitionIfNeeded(state: .collapsed, duration: cardAnimationDuration)
    }
}

