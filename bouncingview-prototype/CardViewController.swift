//
//  CardViewController.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit

/// For Demo purposes, contains only pure UI setup.
/// No complex logic included.
class CardViewController: UIViewController {

    //
    // MARK: - Callbacks

    typealias VoidClosure = () -> Void

    var hideButtonCallback: VoidClosure?

    //
    // MARK: - UI References

    private var contentView: UIView!

    private(set) var topHandlePanel: UIView!
    private(set) var topPanel: UIView!
    private(set) var bottomPanel: UIView!

    private(set) var hideButton: UIView!
    private(set) var hideButtonBackground: UIView!

    //
    // MARK: - View Lifecycle
    
    override func loadView() {

        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .blue

        setupUI()
        setupTextContent()
    }

    private func setupUI() {

        contentView = UIView().then { v in
            v.backgroundColor = .white
            view.addSubview(v) { $0.edges.equalToSuperview() }
        }

        topPanel = UIView().then { v in
            v.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            v.addBottomBorder()

            view.addSubview(v) { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(48)
            }

            //

            _ = UIImageView().then { innerV in

                innerV.image = UIImage(named: "collapseIcon")
                innerV.tintColor = .systemBlue

                v.addSubview(innerV) { make in
                    make.width.equalTo(30)
                    make.height.equalTo(20)
                    make.bottom.equalToSuperview().inset(14)
                    make.left.equalToSuperview().inset(27)
                }
            }
        }

        topHandlePanel = UIView().then { v in
            v.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            v.addTopBorder()

            view.addSubview(v) { make in
                make.top.left.width.equalToSuperview()
                make.height.equalTo(60)
            }

            //

            _ = UIImageView().then { innerV in
                innerV.image = UIImage(named: "handlePlaceholderIcon")
                v.addSubview(innerV) { $0.edges.equalToSuperview() }
            }

            _ = UIButton(type: .system).then { innerV in

                innerV.setImage(UIImage(named: "playSmallIcon"), for: .normal)
                innerV.tintColor = .systemBlue

                v.addSubview(innerV) { make in
                    make.top.right.bottom.equalToSuperview()
                    make.width.equalTo(innerV.snp.height).multipliedBy(1.15)
                }
            }
        }

        bottomPanel = UIView().then { v in
            v.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            v.addTopBorder()

            view.addSubview(v) { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.height.equalTo(79 + UIApplication.safeAreaInsets.bottom)
            }

            //

            let playButton = UIButton().then { innerV in

                innerV.setImage(UIImage(named: "playIcon"), for: .normal)
                innerV.tintColor = .systemBlue

                v.addSubview(innerV) { make in
                    make.width.height.equalTo(51)
                    make.top.equalToSuperview().inset(13)
                    make.centerX.equalToSuperview()
                }
            }

            _ = UIButton(type: .system).then { innerV in

                innerV.setImage(UIImage(named: "rewindIcon"), for: .normal)
                innerV.tintColor = .systemGray

                v.addSubview(innerV) { make in
                    make.width.height.equalTo(33)
                    make.centerY.equalTo(playButton)
                    make.right.equalTo(playButton.snp.left).offset(-22)
                }
            }

            _ = UIButton(type: .system).then { innerV in

                innerV.setImage(UIImage(named: "fastForwardIcon"), for: .normal)
                innerV.tintColor = .systemGray

                v.addSubview(innerV) { make in
                    make.width.height.equalTo(33)
                    make.centerY.equalTo(playButton)
                    make.left.equalTo(playButton.snp.right).offset(22)
                }
            }
        }

        //

        hideButtonBackground = UIView().then { v in
            v.backgroundColor = .red

            view.addSubview(v) { make in
                make.top.bottom.equalTo(topHandlePanel)
                make.left.equalTo(topHandlePanel.snp.right)
                make.right.equalToSuperview()
            }
        }

        hideButton = UIButton(type: .system).then { v in

            v.setTitle("HIDE", for: .normal)
            v.setTitleColor(.white, for: .normal)
            v.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

            v.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)

            hideButtonBackground.addSubview(v) { make in
                make.top.bottom.centerX.equalToSuperview()
                make.width.equalTo(120)
            }
        }
    }

    private func setupTextContent() {

        _ = UITextView().then { v in
            v.font = .systemFont(ofSize: 16, weight: .regular)
            v.textColor = .black
            v.textAlignment = .left
            v.isEditable = false
            v.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

            v.text =
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris nec consectetur lorem. Fusce vitae ultricies purus. Nam felis urna, euismod nec mattis ac, tempor et arcu. Curabitur ut est in ipsum consequat cursus ac ut odio. Nullam posuere ex convallis ex porta sodales. Nullam bibendum magna sit amet sapien pellentesque tempor. Nam facilisis lacinia pellentesque. Donec bibendum in eros ut ornare. Fusce eget nisl tellus. Etiam dolor turpis, placerat in sagittis vel, pretium ut lorem. Nulla a volutpat arcu.

            Duis pulvinar, lectus quis sollicitudin malesuada, leo lectus feugiat arcu, in pulvinar felis velit eget ex. Ut porttitor iaculis justo, tincidunt viverra tortor. Pellentesque id ornare erat. Duis dui tellus, vehicula vitae dictum nec, vehicula at felis. Donec sagittis tempor scelerisque. Vestibulum tincidunt quam ullamcorper erat luctus, ut auctor nibh consectetur. Suspendisse quis semper lorem. Donec placerat imperdiet est id aliquet. Nam purus sem, dictum eu lorem nec, auctor consectetur massa. Nunc dapibus, nunc vitae lobortis finibus, metus lectus ultricies justo, non dictum diam neque sit amet lacus. Donec ac massa in ex commodo ultricies. Pellentesque justo dolor, gravida a aliquam non, pellentesque ac dui. Ut mollis nisl dui, ut iaculis diam dapibus eget. Mauris porttitor sed risus et blandit.

            Phasellus semper imperdiet luctus. Etiam pretium neque sed dui malesuada egestas. Nullam condimentum purus non aliquam porta. Vestibulum mollis nunc et odio porttitor, id efficitur erat bibendum. Ut elementum sem eget sapien dignissim pharetra. Maecenas vitae sapien posuere, dignissim orci sit amet, tincidunt nulla. Maecenas accumsan vitae nunc ac fringilla. Ut scelerisque consectetur enim vel mattis. Nam gravida velit tellus, nec fermentum turpis consequat nec. Mauris sagittis ante ut massa porta, ac molestie arcu mattis. Praesent sed eleifend elit. Vivamus vel vestibulum tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed fringilla aliquam interdum.

            Nulla molestie magna eu finibus consectetur. Sed egestas volutpat tincidunt. Nulla aliquam imperdiet neque vitae dapibus. Sed vestibulum augue id turpis semper scelerisque. Nam id porta justo, vitae pulvinar nunc. Pellentesque in efficitur libero. Nullam dignissim aliquet lacus nec egestas. Praesent blandit pharetra odio ac sagittis. Sed vel lectus vitae augue posuere dapibus quis a augue. Aenean vel eros tellus. Aenean ullamcorper odio a ullamcorper congue. Cras sit amet tortor id augue accumsan luctus. Aliquam leo turpis, tempor id sapien id, convallis dapibus neque. Curabitur sit amet orci consectetur, vehicula ligula porta, luctus turpis. Phasellus at magna eu eros vestibulum facilisis.

            Nam in turpis eget velit lobortis hendrerit eu vitae urna. Nunc iaculis pharetra elementum. Duis in lorem non enim ultrices cursus egestas a magna. Vestibulum et ante ac ligula rutrum laoreet ac ut leo. Mauris vitae convallis nibh. Duis elementum, augue eget pharetra cursus, libero dolor lobortis ex, eget pulvinar est velit vel magna. Nullam nec tincidunt leo, vel egestas urna. In arcu leo, tristique in suscipit ut, dictum a diam. In orci metus, placerat in tempus quis, feugiat nec urna. Praesent ut ultricies neque. Nunc sit amet sem in sapien laoreet mattis nec placerat nibh.

            Fusce tincidunt enim vel fermentum vestibulum. Fusce fringilla, quam ac gravida malesuada, massa leo sodales nunc, a congue massa nisl id nisi. Duis porttitor orci eu lectus congue, ut finibus felis laoreet. Curabitur in rutrum sapien. Donec sit amet lectus sit amet ante laoreet vestibulum non in urna. Proin pulvinar scelerisque aliquam. Nullam non elementum risus. Sed nisi leo, aliquam id magna non, malesuada finibus leo. Aenean ut purus mollis velit ullamcorper consequat vitae et turpis. Ut nisl quam, semper eget tincidunt vitae, aliquam eu ante. Pellentesque in sapien ante. Vestibulum velit urna, vulputate at nibh id, aliquam cursus lorem. Nullam pretium ullamcorper tincidunt. Fusce massa nunc, pharetra ut hendrerit in, egestas in tellus.

            Phasellus auctor dolor nec ligula sagittis, non ullamcorper tellus sagittis. Morbi pretium, nisl vel condimentum mollis, nisi lectus maximus arcu, suscipit tempus erat mi suscipit lacus. Praesent id est a erat auctor tempus. Fusce consectetur, dolor in euismod scelerisque, quam nulla egestas dolor, aliquet ullamcorper eros dolor non turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Fusce consequat iaculis volutpat. Suspendisse eleifend urna felis. Sed sit amet aliquet tellus. Phasellus vestibulum mollis rutrum. Maecenas sit amet metus ac nisi pellentesque varius. Nulla facilisi.

            Etiam ac egestas odio, at efficitur ex. Maecenas at turpis tortor. Sed in sapien vestibulum, laoreet odio vitae, pulvinar nunc. Proin orci felis, congue sed leo ornare, mattis porttitor magna. Mauris congue facilisis massa vel rhoncus. Donec a molestie est. Etiam at ante eu neque rhoncus viverra. Fusce blandit tortor sed orci efficitur, in suscipit felis fringilla. Etiam vehicula neque justo, a luctus risus interdum quis. Pellentesque non laoreet mauris. Suspendisse gravida pharetra arcu, ac lobortis purus posuere eu. Nam luctus augue sem, ac pretium magna ullamcorper eget. Aenean sagittis tincidunt turpis, ac rutrum leo laoreet ac.

            Sed lorem odio, pellentesque vel euismod id, egestas eget tellus. Nulla quis risus vel mauris placerat pretium sit amet non enim. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi sagittis nisi eget orci semper dignissim. Nullam egestas commodo justo, non hendrerit enim maximus nec. Mauris orci est, gravida ut neque pharetra, sodales ullamcorper mi. Interdum et malesuada fames ac ante ipsum primis in faucibus.

            Cras scelerisque mi id accumsan tincidunt. Vivamus iaculis est vel quam finibus, volutpat commodo neque laoreet. Pellentesque ac justo sed nulla blandit bibendum ut a sapien. Nullam congue lectus consequat est gravida, in mattis nisi pulvinar. Donec magna enim, auctor non ultricies ac, posuere nec lectus. Fusce ac est neque. Mauris aliquet non enim sit amet dictum. Fusce auctor odio ipsum, vitae vehicula turpis bibendum quis. Sed non finibus enim. Duis nec lectus ullamcorper, iaculis risus id, varius velit. Donec non turpis accumsan, pellentesque orci id, condimentum risus. In venenatis vehicula ipsum, in aliquam diam suscipit eget. Vivamus viverra aliquet elit ultrices ultrices. Quisque semper elementum nisl, quis fermentum leo mollis nec. Aenean in sagittis neque, ut ullamcorper erat. Phasellus bibendum ullamcorper elementum.
            """

            view.insertSubview(v, belowSubview: topHandlePanel)
            v.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topPanel.snp.bottom)
                make.bottom.equalTo(bottomPanel.snp.top)
            }
        }
    }
}

private extension CardViewController {

    @objc func hideButtonTapped() {
        hideButtonCallback?()
    }
}
