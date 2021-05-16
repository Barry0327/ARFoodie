//
//  LFLiveViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/15.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import LFLiveKit
import YTLiveStreaming
import IHProgressHUD

class LFLiveViewController: UIViewController, LiveStreamTransitioning {

    let lfView = LFLivePreview()

    let input: YTLiveStreaming = YTLiveStreaming()

    var boardcast: LiveBroadcastStreamModel?

    let liveStreamManager = LiveStreamManager()

    lazy var publishButton: UIButton = {

        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.setTitle("開始直播", for: .normal)
        button.addTarget(self, action: #selector(pulishBTNPressed), for: .touchUpInside)

        return button
    }()

    lazy var changeCameraBTN: UIButton = {

        let button = UIButton()
        button.setImage(
            UIImage(named: "icons8-switch-camera-filled-100"),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(changeCameraBTNPressed), for: .touchUpInside)

        let edgeInsets = UIEdgeInsets.init(top: 40, left: 40, bottom: 40, right: 40)
        button.imageEdgeInsets = edgeInsets
        button.layer.applySketchShadow()

        return button
    }()

    lazy var cancelButton: UIButton = {

        let button = UIButton()
        button.setImage(
            UIImage(named: "icon-cross"),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        let edgeInsets = UIEdgeInsets.init(top: 40, left: 40, bottom: 40, right: 40)
        button.imageEdgeInsets = edgeInsets
        button.layer.applySketchShadow()

        return button
    }()

    lazy var liveImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.image = UIImage(named: "live")
        imgView.alpha = 0

        return imgView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        liveStreamManager.delegate = self
        liveStreamManager.boardcast = self.boardcast

        view.addSubview(lfView)
        lfView.addSubview(publishButton)
        lfView.addSubview(changeCameraBTN)
        lfView.addSubview(cancelButton)
        lfView.addSubview(liveImageView)

        setLayout()
    }

    deinit {
        self.lfView.stopPublishing()
    }

    override func viewWillAppear(_ animated: Bool) {

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            self.lfView.prepareForUsing()
        }
    }

    // MARK: - Publish Button Function
    @objc func pulishBTNPressed() {

        if self.publishButton.isSelected {

            let alert = UIAlertController(title: "停止直播", message: "確認要停止直播嗎？", preferredStyle: .alert)

            let confirmAction = UIAlertAction.init(title: "確認", style: .default) { (_) in

                self.publishButton.isSelected = false

                self.publishButton.setTitle("開始直播", for: .normal)

                IHProgressHUD.show()

                self.liveStreamManager.completeBoardcast { [weak self] in

                    guard let self = self else { return }

                    self.lfView.stopPublishing()

                    print("LFView did stop")

                    IHProgressHUD.dismiss()

                    DispatchQueue.main.async { [weak self] in

                        guard let self = self else { return }

                        UIView.animate(withDuration: 0.6, animations: {
                            self.liveImageView.alpha = 0
                        })
                    }
                }

            }

            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)

            alert.addAction(confirmAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)

        } else {

            self.publishButton.isSelected = true

            self.publishButton.setTitle("結束直播", for: .normal)

            IHProgressHUD.show(withStatus: "連線中..")

            self.liveStreamManager.startBoardcast()

        }
    }

    @objc func changeCameraBTNPressed() {

        self.lfView.changeCameraPosition()

    }

    @objc func cancelButtonPressed() {

        guard let boardcast = self.boardcast else {

            self.dismiss(animated: true, completion: nil)

            return
        }

        IHProgressHUD.show()

        self.input.deleteBroadcast(id: boardcast.id) { (success) in

            if success {
                print("Boardcast \(boardcast.id) was deleted!")
            } else {
                print("Failed to delete boardcast")
            }

            IHProgressHUD.dismiss()

            self.dismiss(animated: true, completion: nil)

            self.liveStreamManager.completeBoardcast {

                self.lfView.stopPublishing()

                print("LFView did stop")

            }
        }
    }

    func setLayout() {

        lfView.frame = view.frame

        publishButton.anchor(
            top: nil,
            leading: lfView.leadingAnchor,
            bottom: lfView.bottomAnchor,
            trailing: lfView.trailingAnchor,
            padding: .init(top: 0, left: 100, bottom: 30, right: 100),
            size: .init(width: 0, height: 30)
        )

        changeCameraBTN.anchor(
            top: lfView.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: lfView.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 10),
            size: .init(width: 50, height: 50)
        )

        cancelButton.anchor(
            top: lfView.topAnchor,
            leading: lfView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 20, left: 10, bottom: 0, right: 0),
            size: .init(width: 50, height: 50)
        )

        liveImageView.anchor(
            top: cancelButton.bottomAnchor,
            leading: lfView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 10, bottom: 0, right: 0),
            size: .init(width: 60, height: 45)
        )

    }
}

extension LFLiveViewController: LiveStreamManagerDelegate {

    func manager(_ manager: LiveStreamManager, didFetch broadcastURL: String) {

        self.lfView.startPublishing(withStreamURL: broadcastURL)
        IHProgressHUD.dismiss()

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            UIView.animate(withDuration: 0.6, animations: {
                self.liveImageView.alpha = 1
            })
        }

    }
}
