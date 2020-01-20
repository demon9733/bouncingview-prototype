//
//  MainViewController+Modes.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit

extension MainViewController {

    enum State {
        case hidden // neither card or handle area is visible
        case collapsed // only handle area is visible, card's content is hidden underneath
        case fullscreen // card takes up the whole screen
        case swipeToHide // only handle area is visible, with the Hide button on the right

        func opposite(in direction: DirectionalPanGestureRecognizer.Direction) -> State {

            switch self {
            case .hidden: return self

            case .collapsed:
                switch direction {
                case .horizontal: return .swipeToHide
                case .vertical: return .fullscreen
                }

            case .fullscreen: return .collapsed

            case .swipeToHide:
                switch direction {
                case .horizontal: return .collapsed
                case .vertical: return .fullscreen
                }
            }
        }
    }
}

//

extension MainViewController {

    // Utilities

    typealias VoidClosure = () -> Void

    var tabBar: UIView { tabBarController!.tabBar }
    var navigationBar: UIView { navigationController!.navigationBar }

    var cardView: UIView { cardViewController.view }
    var topPanel: UIView { cardViewController.topPanel }
    var handlePanel: UIView { cardViewController.topHandlePanel }
    var hideButton: UIView { cardViewController.hideButton }

    // Card Setup

    func setupCardViewController() {

        cardViewController = CardViewController().then { vc in

            vc.hideButtonCallback = {
                self.animateTransitionIfNeeded(state: .hidden, duration: self.cardAnimationDuration)
            }

            addChild(vc)
            view.insertSubview(vc.view, belowSubview: tabBar)

            vc.view.clipsToBounds = true
            vc.view.snp.makeConstraints { make in
                make.top.left.right.height.equalToSuperview()
            }
        }

        //

        let addRecognizers = { (view: UIView, includingHorizontal: Bool) in

            _ = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))).then {
                view.addGestureRecognizer($0)
            }

            _ = DirectionalPanGestureRecognizer(
                direction: .vertical,
                target: self,
                action: #selector(self.handlePan(_:))
            ).then {
                $0.delegate = self
                $0.cancelsTouchesInView = false
                view.addGestureRecognizer($0)
            }

            //

            guard includingHorizontal else { return }

            _ = DirectionalPanGestureRecognizer(
                direction: .horizontal,
                target: self,
                action: #selector(self.handlePan(_:))
            ).then {
                $0.delegate = self
                $0.cancelsTouchesInView = false
                view.addGestureRecognizer($0)
            }
        }

        addRecognizers(topPanel, false)
        addRecognizers(handlePanel, true)

        //

        blurEffectView = UIVisualEffectView().then { v in
            v.isUserInteractionEnabled = false
            view.insertSubview(v, belowSubview: cardView)
            v.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }

    // Programmatic Transitions

    func animateTransitionIfNeeded(state: State, duration: TimeInterval) {

        guard self.state != state else { return }
        self.state = state

        if runningAnimators.isEmpty == false {

            runningAnimators.forEach {
                $0.stopAnimation(true)
                $0.finishAnimation(at: .current)
            }

            runningAnimators = []
        }

        // Frame updates

        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
        addToRunningAnimators(frameAnimator, animation: {

            switch self.state {
            case .fullscreen:

                self.cardView.snp.updateConstraints { make in
                    make.top.equalToSuperview()
                }

                self.topPanel.snp.updateConstraints { update in
                    update.height.equalTo(48 + UIApplication.safeAreaInsets.top)
                }

                self.handlePanel.snp.updateConstraints { update in
                    update.left.equalToSuperview()
                }

                self.navigationBar.frame.origin.y = -self.navigationBar.frame.height
                self.tabBar.frame.origin.y = UIScreen.main.bounds.height

            case .collapsed:

                self.cardView.snp.updateConstraints { make in
                    make.top
                        .equalToSuperview()
                        .offset(UIScreen.main.bounds.height - self.handleAreaHeight - self.tabBar.frame.height)
                }

                self.topPanel.snp.updateConstraints { update in
                    update.height.equalTo(48)
                }

                self.handlePanel.snp.updateConstraints { update in
                    update.left.equalToSuperview().offset(0)
                }

                self.navigationBar.frame.origin.y = UIApplication.safeAreaInsets.top
                self.tabBar.frame.origin.y = UIScreen.main.bounds.height - self.tabBar.frame.height

            case .swipeToHide:

                self.cardView.snp.updateConstraints { make in
                    make.top
                        .equalToSuperview()
                        .offset(UIScreen.main.bounds.height - self.handleAreaHeight - self.tabBar.frame.height)
                }

                self.topPanel.snp.updateConstraints { update in
                    update.height.equalTo(48)
                }

                self.handlePanel.snp.updateConstraints { update in
                    update.left.equalToSuperview().offset(-self.handleAreaSwipeWidth)
                }

                self.navigationBar.frame.origin.y = UIApplication.safeAreaInsets.top
                self.tabBar.frame.origin.y = UIScreen.main.bounds.height - self.tabBar.frame.height

            case .hidden:

                self.cardView.snp.updateConstraints { make in
                    make.top
                        .equalToSuperview()
                        .offset(UIScreen.main.bounds.height - self.tabBar.frame.height)
                }

                self.topPanel.snp.updateConstraints { update in
                    update.height.equalTo(48)
                }

                self.handlePanel.snp.updateConstraints { update in
                    update.left.equalToSuperview().offset(-self.handleAreaSwipeWidth)
                }

                self.navigationBar.frame.origin.y = UIApplication.safeAreaInsets.top
                self.tabBar.frame.origin.y = UIScreen.main.bounds.height - self.tabBar.frame.height
            }

            self.view.layoutIfNeeded()

        }, completion: {
            switch self.state {
            case .hidden: // Returning `handlePanel` to it's initial position.
                self.handlePanel.snp.updateConstraints { $0.left.equalToSuperview() }

            case .collapsed, .fullscreen, .swipeToHide:
                break
            }
        })

        // Blur effect updates

        let timing: UITimingCurveProvider
        switch state {
        case .fullscreen, .swipeToHide:
            timing = UICubicTimingParameters(animationCurve: .linear)

        case .collapsed, .hidden:
            timing = UICubicTimingParameters(
                controlPoint1: CGPoint(x: 0.1, y: 0.65),
                controlPoint2: CGPoint(x: 0.25, y: 0.8)
            )
        }

        let blurAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        blurAnimator.scrubsLinearly = false
        addToRunningAnimators(blurAnimator, animation: {

            switch self.state {
            case .fullscreen: self.blurEffectView.effect = UIBlurEffect(style: .dark)
            case .collapsed, .swipeToHide, .hidden: self.blurEffectView.effect = nil
            }
        })

        // Alpha updates

        let alphaAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
        addToRunningAnimators(alphaAnimator, animation: {

            switch self.state {
            case .fullscreen:
                self.topPanel.alpha = 1
                self.handlePanel.alpha = 0
                self.hideButton.alpha = 0
                self.hideButton.transform = .init(scaleX: 0.3, y: 0.3)

            case .collapsed:
                self.topPanel.alpha = 0
                self.handlePanel.alpha = 1
                self.hideButton.alpha = 0
                self.hideButton.transform = .init(scaleX: 0.3, y: 0.3)

            case .swipeToHide:
                self.topPanel.alpha = 0
                self.handlePanel.alpha = 1
                self.hideButton.alpha = 1
                self.hideButton.transform = .identity

            case .hidden:
                self.topPanel.alpha = 0
                self.handlePanel.alpha = 0
                self.hideButton.alpha = 0
                self.hideButton.transform = .init(scaleX: 0.3, y: 0.3)
            }
        })
    }
}

//
// MARK: - Animators Progress Management

private extension MainViewController {

    func startInteractiveTransition(state: State, duration: TimeInterval) {

        animateTransitionIfNeeded(state: state, duration: duration)

        progressWhenInterrupted = [:]
        for animator in runningAnimators {
            animator.pauseAnimation()
            progressWhenInterrupted[animator] = animator.fractionComplete
        }
    }

    func reverseRunningAnimations(in direction: DirectionalPanGestureRecognizer.Direction) {

        for animator in runningAnimators { animator.isReversed = !animator.isReversed }
        state = previousState ?? state.opposite(in: direction)
    }

    func updateInteractiveTransition(in direction: DirectionalPanGestureRecognizer.Direction, translation: CGPoint) {

        let totalAnimationDistance, fractionComplete: CGFloat

        switch direction {
        case .vertical:
            totalAnimationDistance = cardView.bounds.height - handleAreaHeight - tabBar.bounds.height
            fractionComplete = translation.y / totalAnimationDistance

        case .horizontal:
            totalAnimationDistance = handleAreaSwipeWidth
            fractionComplete = translation.x / totalAnimationDistance
        }

        //

        for animator in runningAnimators {

            guard let progressWhenInterrupted = progressWhenInterrupted[animator] else { continue }
            let relativeFractionComplete = fractionComplete + progressWhenInterrupted

            if (state == .fullscreen && relativeFractionComplete > 0) ||
                (state == .swipeToHide && relativeFractionComplete > 0) ||
                (state == .collapsed && relativeFractionComplete < 0) {
                animator.fractionComplete = 0

            } else if (state == .fullscreen && relativeFractionComplete < -1) ||
                (state == .swipeToHide && relativeFractionComplete < -1) ||
                (state == .collapsed && relativeFractionComplete > 1) {
                animator.fractionComplete = 1

            } else {
                animator.fractionComplete = abs(fractionComplete) + progressWhenInterrupted
            }
        }
    }

    func continueInteractiveTransition(in direction: DirectionalPanGestureRecognizer.Direction, cancel: Bool) {

        if cancel { reverseRunningAnimations(in: direction) }

        for animator in runningAnimators {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }

        UIView.animate(withDuration: 0.3) { self.setNeedsStatusBarAppearanceUpdate() }
    }

    //

    func isCollapseGestureCancelled(_ recognizer: DirectionalPanGestureRecognizer) -> Bool {

        let velocity = recognizer.velocity(in: view)
        let dirVelocity: CGFloat

        switch recognizer.direction {
        case .vertical: dirVelocity = velocity.y
        case .horizontal: dirVelocity = velocity.x
        }

        guard dirVelocity != 0 else { return false }
        let isPanningDown = dirVelocity > 0

        return (state == .fullscreen && isPanningDown)
            || (state == .swipeToHide && isPanningDown)
            || (state == .collapsed && !isPanningDown)
    }

    func addToRunningAnimators(_ animator: UIViewPropertyAnimator,
                               animation: @escaping VoidClosure,
                               completion: VoidClosure? = nil) {

        runningAnimators.append(animator)
        animator.addAnimations { animation() }

        animator.addCompletion { _ in
            self.runningAnimators = self.runningAnimators.filter { $0 != animator }
            animation()
            completion?()
        }

        animator.startAnimation()
    }
}

//
// MARK: - Handling Gesture Recognizers

private extension MainViewController {

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {

        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(
                state: state.opposite(in: .vertical),
                duration: cardAnimationDuration
            )

        default: break
        }
    }

    @objc func handlePan(_ recognizer: DirectionalPanGestureRecognizer) {

        switch recognizer.state {
        case .began:
            startInteractiveTransition(
                state: state.opposite(in: recognizer.direction),
                duration: cardAnimationDuration
            )

        case .changed:
            let translation = recognizer.translation(in: cardView)
            updateInteractiveTransition(in: recognizer.direction, translation: translation)

        case .cancelled, .failed:
            continueInteractiveTransition(in: recognizer.direction, cancel: true)

        case .ended:
            let isCancelled = isCollapseGestureCancelled(recognizer)
            continueInteractiveTransition(in: recognizer.direction, cancel: isCancelled)

        default: break
        }
    }
}

//
// MARK: - UIGestureRecognizerDelegate Conformance

extension MainViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
}
