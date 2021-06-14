//
//  RickRollPlayerInterfaceController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by Никита Лужбин on 14.06.2021.
//

import WatchKit
import Foundation
import AVFoundation


class RickRollPlayerInterfaceController: WKInterfaceController {

    // MARK: - Instance Properties

    // MARK: -

    var audioPlayer: AVAudioPlayer?

    // MARK: - Instance Methods

    @IBAction private func playButtonDidTapped() {
        self.audioPlayer?.play()
    }

    @IBAction private func pauseButtonDidTapped() {
        self.audioPlayer?.pause()
    }

    @IBAction private func reloadButttonDidTapped() {
        self.audioPlayer?.play(atTime: .zero)
    }

    // MARK: -

    private func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "NGGYU", withExtension: "mp3") else {
            return
        }

        try? self.audioPlayer = AVAudioPlayer(contentsOf: url)
    }

    // MARK: - WKInterfaceController

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.setupPlayer()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
