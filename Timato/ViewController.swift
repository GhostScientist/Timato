//
//  ViewController.swift
//  Timato
//
//  Created by Dakota Kim on 5/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//
//  This is a minimal pomodoro timer inspired by the Pomodoro
//  technique popularized by xxx. This is also a learning
//  process to learn how to create an app store listing.
//  I will update the project with features as I see fit, if at all.

import UIKit
import ChameleonFramework
import Foundation
import AVFoundation
//I will use the chameleron framework to create Flat colors.
//During the work cycle, it will be a flat green.
//During the break cycle, it will be a flat red.

class ViewController: UIViewController {

    
    @IBOutlet weak var inspirationalQuoteLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var inspirationQuote = ["Hero is your middle name.",
                            "All the strength you need is inside.",
                            "You can go anywhere.",
                            "Success is the best revenge."
    ]
    
    let workTime = 1500
    var workTimeLength = 1500
    let shortBreakTime = 300
    let longBreakTime = 1800
    
    var timer = Timer()
    var player : AVAudioPlayer?
    var roundCounter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatRed
        timerLabel.text = String(format: "%02d", (workTimeLength/60)) + ":" + String(format: "%02d", (workTimeLength % 60))
        inspirationalQuoteLabel.text = inspirationQuote[Int(arc4random_uniform(UInt32(inspirationQuote.count)))]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func counter() {
        workTimeLength -= 1
        timerLabel.text = "\(workTimeLength / 60):" + String(format: "%02d", (workTimeLength % 60))
        
        if workTimeLength == 0 && (roundCounter % 2 == 1) {
            timer.invalidate()
            roundCounter += 1
            if roundCounter % 10 == 0 {
                workTimeLength = longBreakTime
            }
            else {
                workTimeLength = shortBreakTime
            }
            //playSound()
            let alert = UIAlertController(title: "Break Time!", message: "You have a \(workTimeLength / 60) minute break. Tap 'Go' to begin.", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Go", style: .default, handler: { (UIAlertAction) in
                self.play()
            })
            
            alert.addAction(continueAction)
            present(alert, animated: true, completion: nil)
            
        }
            
        else if workTimeLength == 0 && (roundCounter % 2 == 0) {
            timer.invalidate()
            roundCounter += 1
            workTimeLength = workTime
            //playSound()
            let alert = UIAlertController(title: "Work Time!", message: "You have \(workTimeLength / 60) minutes of work. Tap 'Go' to begin.", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Go", style: .default, handler: { (UIAlertAction) in
                self.play()
                self.inspirationalQuoteLabel.text = self.inspirationQuote[Int(arc4random_uniform(UInt32(self.inspirationQuote.count)))]
            })
            
            alert.addAction(continueAction)
            present(alert, animated: true, completion: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func play() {
        view.backgroundColor = UIColor.flatGreen
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        playButtonOutlet.isEnabled = false
        stopButtonOutlet.isEnabled = true
    }

    
    @IBOutlet weak var playButtonOutlet: UIButton!
    
    @IBAction func playButtonTapped(_ sender: Any) {
        play()
    }
    
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        view.backgroundColor = UIColor.flatRed
        timer.invalidate()
        playButtonOutlet.isEnabled = true
        stopButtonOutlet.isEnabled = true
    }
    
}

