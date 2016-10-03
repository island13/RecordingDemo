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

class AudioEngineViewController: UIViewController {
    
    private var audioEngine: AVAudioEngine!
    private var file: AVAudioFile?
    private var player: AVPlayer?
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let audioEngine = audioEngine, let inputNode = audioEngine.inputNode {
            inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            self.audioEngine = nil
            button.setTitle("Record", for: .normal)
            return
        }
        
        try! AVAudioSession.sharedInstance().setPreferredSampleRate(48_000)
        try! AVAudioSession.sharedInstance().setActive(true)
        try! AVAudioSession.sharedInstance().setPreferredSampleRate(48_000)
        
        audioEngine = AVAudioEngine()
        if let inputNode = audioEngine?.inputNode {
            inputNode.volume = 1
            audioEngine.mainMixerNode.volume = 1
            audioEngine.mainMixerNode.outputVolume = 1
            audioEngine.connect(inputNode, to: audioEngine.mainMixerNode,
                                format: inputNode.inputFormat(forBus: 0))
            
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 48000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.caf")
            print("\(audioFilename)")
            file = try! AVAudioFile(forWriting: audioFilename, settings: settings)
            
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
            inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputNode.inputFormat(forBus: 0)) { buffer, time in

                do {
                    try self.file!.write(from: buffer)
                    print("tap")
                    
                } catch _ {
                    assertionFailure()
                }
                
            }
            audioEngine.prepare()
            do {
                try audioEngine.start()

            } catch _ {
                assertionFailure()
            }
            button.setTitle("Stop", for: .normal)
        }
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        player = AVPlayer(url: audioFilename)
        
//        assert(player!.status == .readyToPlay)
        player!.play()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}
