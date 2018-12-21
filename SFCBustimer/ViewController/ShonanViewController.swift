//
//  ShonanViewController.swift
//  Dotinstall
//
//  Created by satoshi on 2018/12/17.
//  Copyright © 2018年 satoshi. All rights reserved.
//

import UIKit
//import MBCircularProgressBar


class ShonanViewController: UIViewController {
    
//    var cnt : Int = 0
    var timer: Timer?
    
    var duration = 0
    
    var progressWidth: Float = 1.0
    
    
    
    let settingKey = "timerValue"

    @IBOutlet weak var countDown: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UserDefaults.standard
        settings.register(defaults: [settingKey: 61])
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                return
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerStop(_:)), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainSeconds = timerValue - duration
        let minutes = remainSeconds / 60
        let seconds = remainSeconds % 60
        countDown.text = "あと\(minutes)分\(seconds)秒"
        progressView.setProgress(progressView.progress + 0.01, animated: true)
        return remainSeconds
        
    }
    
    
    @objc func timerStop(_ timer:Timer){
         let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainSeconds : Float = Float(timerValue - duration)
        let percentage = progressWidth / remainSeconds
          progressWidth -= percentage
        duration += 1
        if displayUpdate() <= 0 {
            duration = 0
            timer.fire()
        }
        if progressWidth == 0 {
            progressWidth = 1.0
        }
        progressView.progress = progressWidth
    }
}
