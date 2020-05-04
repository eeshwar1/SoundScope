//
//  Recording.swift
//  SoundScope
//
//  Created by Venky Venkatakrishnan on 5/3/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import AVFoundation
import QuartzCore
import Foundation

public class Recording: NSObject, AVAudioRecorderDelegate {
    
    @objc public enum State: Int {
        case None, Record, Play
    }
    
    
    static var directory: String {
        
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0]
    }
    
    public private(set) var url: NSURL?
    
    public var state: State
    public var bitRate = 192000
    public var sampleRate = 44100.0
    public var channels = 1
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    
    private var filename = "foo.m4a"
    
    // MARK: - Initializers
    
    override init() {
        url = NSURL(fileURLWithPath: Recording.directory).appendingPathComponent(filename)! as NSURL
        self.state = .None
    }
    
    // MARK: - Record
    
    private func prepare() throws {
        let settings: [String: AnyObject] = [
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]
        
        recorder = try AVAudioRecorder(url: url! as URL, settings: settings)
        recorder?.delegate = self
        recorder?.prepareToRecord()
    
    }
    
    public func record() throws {
        print("Saving to \(String(describing: url))")
        
        if recorder == nil {
            try prepare()
        }
        recorder?.record()
        state = .Record
        
        print("state: \(state.rawValue)")
        
    }
    
    // MARK: - Playback
    
    public func play() throws {
        player = try AVAudioPlayer(contentsOf: url! as URL)
        player?.volume = 5.0
        player?.play()
        state = .Play
        
        print("state: \(state.rawValue)")
    }
    
    public func stop() {
        
        switch state {
        case .Play:
            player?.stop()
            player = nil
        case .Record:
            recorder?.stop()
            recorder = nil
        default:
            break
        }
        state = .None
        print("state: \(state.rawValue)")
    }
    
    // MARK: - Delegates
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        print("audioRecorderEncodeErrorDidOccur \(String(describing: error?.localizedDescription))")
    }
    
    
}
