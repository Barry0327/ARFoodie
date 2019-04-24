//
//  LiveStreamManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/16.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import YTLiveStreaming
import StatusAlert

class LiveStreamManager: LiveStreamTransitioning {

    var boardcast: LiveBroadcastStreamModel?

    static let shared: LiveStreamManager = LiveStreamManager()

    let input: YTLiveStreaming = YTLiveStreaming()

    weak var delegate: LiveStreamManagerDelegate?

    func startBoardcast() {

        guard let boardcast = self.boardcast else {
            print("Boardcast is nil")
            return
        }
        self.input.startBroadcast(boardcast, delegate: self) { (streamName, streamURL, _) in

            guard
                let streamName = streamName,
                let streamURL = streamURL
                else {
                    return
            }

            let url = "\(streamURL)/\(streamName)"

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.delegate?.manager(LiveStreamManager.shared, didFetch: url)
            }
        }
    }

    func completeBoardcast(completionhandler: @escaping () -> Void) {

        guard let boardcast = self.boardcast else {
            print("Boardcast is nil")
            return
        }

        self.input.completeBroadcast(boardcast) { (sucess) in

            if sucess {
                print("sucess to stop")

            } else {

//                let alert = StatusAlert()
//                alert.title = "停止直播失敗"
//                alert.message = "您可以嘗試從Youtube上停止直播"
//                alert.alertShowingDuration = 3
//                alert.showInKeyWindow()
            }

            completionhandler()
        }
    }
}
