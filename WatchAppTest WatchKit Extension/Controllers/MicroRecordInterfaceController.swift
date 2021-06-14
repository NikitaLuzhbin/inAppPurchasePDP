//
//  MicroRecordInterfaceController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by Никита Лужбин on 14.06.2021.
//

import WatchKit
import Foundation
import AVFoundation

class MicroRecordInterfaceController: WKInterfaceController {

    // MARK: - Instance Properties

    private var audioPlayer: AVAudioPlayer?

    private var saveURL: URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recordedAudio.wav")
    }

    // MARK: - Instance Methods

    @IBAction private func onRecordDidTapped() {
        self.presentAudioRecorderController(withOutputURL: self.saveURL,
                                            preset: .narrowBandSpeech,
                                            options: nil,
                                            completion: { success, error in
                                                if success {
                                                    print("Success audio recoed")
                                                } else if let error = error {
                                                    print("Audio Record error: \(error.localizedDescription)")
                                                }
                                            })
    }
    
    @IBAction private func onListenDidTapped() {
        guard FileManager.default.fileExists(atPath: saveURL.path) else {
            print("Record doesn't exist")
            return
        }

        try? self.audioPlayer = AVAudioPlayer(contentsOf: self.saveURL)
        self.audioPlayer?.play()
    }

    // MARK: - WKInterfaceController
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
