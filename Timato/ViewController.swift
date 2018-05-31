//
//  ViewController.swift
//  Timato
//
//  Created by Dakota Kim on 5/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//
//  This is a minimal pomodoro timer inspired by the Pomodoro
//  technique popularized by Francisco Cirillo. This is also a learning
//  process to learn how to create an app store listing.
//  I will update the project with features as I see fit, if at all.
//

import UIKit
import ChameleonFramework
import Foundation
import AVFoundation
import UserNotifications
//I will use the chameleron framework to create Flat colors.
//During the work cycle, it will be a flat green.
//During the break cycle, it will be a flat red.

class ViewController: UIViewController {

    @IBOutlet weak var inspirationalQuoteLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var inspirationQuote = ["Hero is your middle name.",
                            "All the strength you need is inside.",
                            "You can go anywhere.",
                            "Success is the best revenge.",
                            "I believe in you."
    ]
    
    let workTime = 5
    var workTimeLength = 5
    let shortBreakTime = 5
    let longBreakTime = 20
    
    var timeViewLeftForeground = Date()
    var isActive = false
    
    var timer = Timer()
    var player : AVAudioPlayer?
    var roundCounter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if error != nil {
                print("Authorization Unsuccessful")
            } else {
                print("Authorization Successful")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateTimer), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.saveTime), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.pushAlert), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        changeColorTheme(color: UIColor.flatRed, lightenedColor: UIColor(hexString: "FF7364")!)
        print(UIColor.flatRed.hexValue())
        view.backgroundColor = UIColor.flatRed
        timerLabel.text = String(format: "%01d", (workTimeLength/60)) + ":" + String(format: "%02d", (workTimeLength % 60))
        inspirationalQuoteLabel.text = inspirationQuote[Int(arc4random_uniform(UInt32(inspirationQuote.count)))]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        timeViewLeftForeground = Date()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func counter() {
        workTimeLength -= 1
        timerLabel.text = "\(workTimeLength / 60):" + String(format: "%02d", (workTimeLength % 60))
        pushAlert()
        //timeViewLeftForeground = Date()
        print(workTimeLength)
        
    }
    
    func play() {
        scheduledNotification(timeUntil: TimeInterval(workTimeLength)) { (success) in
            if success {
                print("Successfully Notified")
            } else {
                print("Problem Notifying")
            }
        }
        isActive = true
        changeColorTheme(color: UIColor.flatGreen, lightenedColor: UIColor(hexString: "7EE7A8")!)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
        playButtonOutlet.isEnabled = false
        stopButtonOutlet.isEnabled = true
    }
    
    func changeColorTheme(color: UIColor, lightenedColor: UIColor) {
        print(color.hexValue())
        self.view.backgroundColor = color
        playButtonOutlet.layer.shadowColor = UIColor.flatBlack.cgColor
        playButtonOutlet.layer.shadowOffset = CGSize(width: 5.0, height: 2.0)
        playButtonOutlet.layer.shadowOpacity = 1.0
        playButtonOutlet.layer.shadowRadius = 5.0
        playButtonOutlet.layer.masksToBounds = false
        stopButtonOutlet.layer.shadowColor = UIColor.flatBlack.cgColor
        stopButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        stopButtonOutlet.layer.shadowOpacity = 1.0
        stopButtonOutlet.layer.shadowRadius = 0.0
        stopButtonOutlet.layer.masksToBounds = false
        playButtonOutlet.backgroundColor = lightenedColor
        playButtonOutlet.setTitleColor(ContrastColorOf(color, returnFlat: true), for: .normal)
        playButtonOutlet.layer.cornerRadius = 12.5
        playButtonOutlet.clipsToBounds = true
        stopButtonOutlet.backgroundColor = lightenedColor
        stopButtonOutlet.setTitleColor(ContrastColorOf(color, returnFlat: true), for: .normal)
        stopButtonOutlet.layer.cornerRadius = 12.5
        stopButtonOutlet.clipsToBounds = true
        inspirationalQuoteLabel.textColor = ContrastColorOf(color, returnFlat: true)
        timerLabel.textColor = ContrastColorOf(color, returnFlat: true)
    }

    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBAction func playButtonTapped(_ sender: Any) {
        if stopButtonOutlet.currentTitle == "Reset" {
            stopButtonOutlet.setTitle("Stop", for: .normal)
        }
        play()
    }
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBAction func stopButtonTapped(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        changeColorTheme(color: UIColor.flatRed, lightenedColor: UIColor(hexString: "FF7364")!)
        if isActive {
            isActive = false
            print("Is this being tapped? If you can see this, yes!")
            timer.invalidate()
            playButtonOutlet.isEnabled = true
            stopButtonOutlet.setTitle("Reset", for: .normal)
        } else if !isActive && stopButtonOutlet.currentTitle! ==  "Reset" {
            let alert = UIAlertController(title: "Reset Timer?", message: "Would you like to reset the timer?", preferredStyle: .alert)
            let refusedAction = UIAlertAction(title: "No", style: .default, handler: nil)
            let offeredAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                if self.roundCounter % 2 == 1 {
                    self.workTimeLength = 1500
                    self.timerLabel.text = String(format: "%01d", (self.workTimeLength/60)) + ":" + String(format: "%02d", (self.workTimeLength % 60))
                } else if self.roundCounter % 2 == 0 && self.roundCounter % 10 == 0 {
                    self.workTimeLength = 1800
                    self.timerLabel.text = String(format: "%01d", (self.workTimeLength/60)) + ":" + String(format: "%02d", (self.workTimeLength % 60))
                } else if self.roundCounter % 2 == 0 {
                    self.workTimeLength = 300
                    self.timerLabel.text = String(format: "%01d", (self.workTimeLength/60)) + ":" + String(format: "%02d", (self.workTimeLength % 60))
                }
                self.stopButtonOutlet.setTitle("Stop", for: .normal)
                self.stopButtonOutlet.isEnabled = false
            }
            print("Reset is being tapped.")
            alert.addAction(offeredAction)
            alert.addAction(refusedAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateTimer() {
        if isActive {
            print("Does timeViewLeftForeground have a value? It is \(timeViewLeftForeground)")
            let difference = Int(timeViewLeftForeground.timeIntervalSinceNow)
            print("The difference is \(difference)")
            if -difference >= workTimeLength {
                workTimeLength = 0
                timer.invalidate()
                timerLabel.text = String(format: "%01d", (self.workTimeLength/60)) + ":" + String(format: "%02d", (self.workTimeLength % 60))
            } else if (-difference > 0) && (-difference < workTimeLength) {
                workTimeLength += difference
            }
        }
    }
    
    @objc func saveTime() {
        timeViewLeftForeground = Date()
        print("Date saved." )
    }
    
    @objc func pushAlert() {
        if workTimeLength == 0 && (roundCounter % 2 == 1) {
            timer.invalidate()
            isActive = false
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
            let pauseAction = UIAlertAction(title: "Pause", style: .default) { (UIAlertAction) in
                self.stopButtonTapped(self)
                self.isActive = false
                self.playButtonOutlet.isEnabled = true
                self.timerLabel.text = String(format: "%01d", (self.workTimeLength/60)) + ":" + String(format: "%02d", (self.workTimeLength % 60))
            }
            alert.addAction(continueAction)
            alert.addAction(pauseAction)
            present(alert, animated: true, completion: nil)
        } else if workTimeLength == 0 && (roundCounter % 2 == 0) {
            isActive = false
            timer.invalidate()
            roundCounter += 1
            workTimeLength = workTime
            //playSound()
            let alert = UIAlertController(title: "Work Time!", message: "You have \(workTimeLength / 60) minutes of work. Tap 'Go' to begin.", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Go", style: .default, handler: { (UIAlertAction) in
                self.play()
                self.inspirationalQuoteLabel.text = self.inspirationQuote[Int(arc4random_uniform(UInt32(self.inspirationQuote.count)))]
            })
            let pauseAction = UIAlertAction(title: "Pause", style: .default) { (UIAlertAction) in
                self.timer.invalidate()
            }
            alert.addAction(continueAction)
            alert.addAction(pauseAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scheduledNotification(timeUntil: TimeInterval, completion: @escaping (_ success: Bool) -> ()){
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeUntil, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Timer's Up!"
        content.body = "Great job! Return to Timato to see what's up next!"
        let request = UNNotificationRequest(identifier: "tempIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

