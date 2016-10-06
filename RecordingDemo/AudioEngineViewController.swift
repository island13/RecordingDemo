//
//  AudioEngineViewController.swift
//  RecordingDemo
//
//  Created by Andreas Svensson on 10/3/16.
//  Copyright © 2016 Rooftop Media, Inc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioEngineViewController: UIViewController, AVAudioPlayerDelegate {

    private var audioEngine = AVAudioEngine()
    private var file: AVAudioFile?
    private var player: AVAudioPlayer?
    private let filename = "recording.caf"
    private var sampleRate: Double!
    private var channelCount: Int!

    @IBOutlet weak var button: UIButton!

    @IBAction func buttonTapped(_ sender: UIButton) {
        do {
            if audioEngine.isRunning {
                audioEngine.inputNode?.removeTap(onBus: 0)
                audioEngine.stop()
                button.setTitle("Record", for: .normal)
                return
            }
            setupAudioSession()

            assert(audioEngine.inputNode != nil)
            if let inputNode = audioEngine.inputNode {
                let format = inputNode.inputFormat(forBus: 0)

                audioEngine.connect(inputNode, to: audioEngine.mainMixerNode, format: format)
                audioEngine.mainMixerNode.outputVolume = 0

                audioEngine.prepare()
                print("Audio engine: \(audioEngine)")


                let settings: [String : Int] = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: Int(sampleRate),
                    AVNumberOfChannelsKey: channelCount,
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ]
                print("Settings \(settings)")
                let audioUrl = getDocumentsDirectory().appendingPathComponent(filename)
                print("\(audioUrl)")
                file = try AVAudioFile(forWriting: audioUrl, settings: settings)

                inputNode.installTap(onBus: 0, bufferSize: 4096, format: nil) { buffer, time in

                    do {
                        try self.file!.write(from: buffer)
                        print("\(buffer.format.sampleRate)")

                    } catch _ {
                        assertionFailure()
                    }

                }
                try audioEngine.start()
                button.setTitle("Stop", for: .normal)
            }

        } catch _ {
            assertionFailure()
        }
    }


    @IBAction func play(_ sender: UIButton) {
        let audioUrl = getDocumentsDirectory().appendingPathComponent(filename)

        player = try! AVAudioPlayer(contentsOf: audioUrl)
        player!.delegate = self
        player?.volume = 1

        player!.play()
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryMultiRoute)
            try audioSession.setActive(true)
            sampleRate = audioSession.sampleRate
            channelCount = audioSession.inputNumberOfChannels

            if let availableInputs = audioSession.availableInputs {
                for input in availableInputs {
                    if input.portType == AVAudioSessionPortBuiltInMic {
                        try audioSession.setPreferredInput(input)
                    }

                }
            }

            print("audio session \(audioSession.availableInputs)")

            if let input = audioSession.currentRoute.inputs.first, let dataSources = input.dataSources,
                input.portType == AVAudioSessionPortBuiltInMic {

                for dataSource in dataSources {
                    if let orientation = dataSource.orientation, orientation == AVAudioSessionOrientationBottom {
                        try audioSession.setInputDataSource(dataSource)
                        print("Selected bottom microphone")
                        break
                    }
                }
            }


        } catch _ {
            assertionFailure()
        }

        print("Current route \(audioSession.currentRoute)")

    }

}
