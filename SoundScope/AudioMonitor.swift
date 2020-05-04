//
//  AudioMonitor.swift
//  SoundScope
//
//  Created by Venky Venkatakrishnan on 4/27/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Foundation
import AVFoundation

class AudioMonitor: ObservableObject {
    
    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    private var currentSample: Int
    private var numberOfSamples: Int
    
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        
        self.numberOfSamples = numberOfSamples
        self.soundSamples = [Float] (repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        // let audioSession = AVCaptureSession()
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
               AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
               AVSampleRateKey: 44100.0,
               AVNumberOfChannelsKey: 1,
               AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
           ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            startMonitoring()
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    private func startMonitoring() {
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer)  in
            self.audioRecorder.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
        
    }

    deinit {
        timer?.invalidate()
        audioRecorder.stop()
    }

}
