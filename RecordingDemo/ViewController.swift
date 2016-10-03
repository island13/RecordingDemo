//
//  ViewController.swift
//  RecordingDemo
//
//  Created by Andreas Svensson on 10/3/16.
//  Copyright © 2016 Rooftop Media, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var recorder: AVAudioRecorder?
    
    private var audioEngine: AVAudioEngine?

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        if let recorder = recorder, recorder.isRecording {
            recorder.stop()
            self.recorder = nil
            button.setTitle("Record", for: .normal)
            return
        }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print("\(audioFilename)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 48000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()
            button.setTitle("Stop", for: .normal)
        } catch _ {
            assertionFailure()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

