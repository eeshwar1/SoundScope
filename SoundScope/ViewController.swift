//
//  ViewController.swift
//  SoundScope
//
//  Created by Venky Venkatakrishnan on 4/27/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa
import Combine

let numberOfSamples: Int = 10

class ViewController: NSViewController {
    
    @IBOutlet weak var labelLevel: NSTextField!
    @IBOutlet var progressLevel1: NSProgressIndicator!
    @IBOutlet var progressLevel2: NSProgressIndicator!
    @IBOutlet var progressLevel3: NSProgressIndicator!
    @IBOutlet var progressLevel4: NSProgressIndicator!
    @IBOutlet var progressLevel5: NSProgressIndicator!
    @IBOutlet var progressLevel6: NSProgressIndicator!
    @IBOutlet var progressLevel7: NSProgressIndicator!
    @IBOutlet var progressLevel8: NSProgressIndicator!
    @IBOutlet var progressLevel9: NSProgressIndicator!
    @IBOutlet var progressLevel10: NSProgressIndicator!
    
    var progressLevel: [NSProgressIndicator]  = []
  
    
    private var mic = AudioMonitor(numberOfSamples: numberOfSamples)
    var recording: Recording = Recording()
    
    var timer: Timer?
    
    var levelFormatter: NumberFormatter = NumberFormatter()
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (100 / 25)) // scaled to max at 300 (our height of our bar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.progressLevel.append(contentsOf: [progressLevel1, progressLevel2, progressLevel3, progressLevel4, progressLevel5, progressLevel6, progressLevel7, progressLevel8, progressLevel9,
        progressLevel10])

    }

    @objc func captureAudio() {
        
        var maxLevel:CGFloat = 0
        for (index,level) in mic.soundSamples.enumerated() {
                
            let normLevel = self.normalizeSoundLevel(level: level)
            
            if normLevel > maxLevel {
                maxLevel = normLevel
            }
            
            progressLevel[index].doubleValue = Double(normLevel)

            
            }
     
        labelLevel.stringValue = String(format: "%06.2f",maxLevel)
 
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK :- Actions
    
    @IBAction func monitorAudio(_ sender: NSButton) {

        if sender.title == "Start Monitoring" {

             timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(captureAudio), userInfo: nil, repeats: true)
            sender.title = "Stop Monitoring"
        }
        else
        {
            timer?.invalidate()
            sender.title = "Start Monitoring"
            labelLevel.floatValue = 0.0
        }


    }
    
    @IBAction func record(_ sender: NSButton) {
        do {
            try self.recording.record()
        } catch {
            print("Error recording: \(error.localizedDescription)")
        }
    }
       
    
    
    @IBAction func play(_ sender: NSButton) {
        do {
            try self.recording.play()
        
        } catch {
                   print("Error play: \(error.localizedDescription)")
        }
      }
    
    @IBAction func stop(_ sender: NSButton) {
        self.recording.stop()
      }
    
    
    
}

