//
//  ShonanViewController.swift
//  Dotinstall
//
//  Created by satoshi on 2018/12/17.
//  Copyright © 2018年 satoshi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//
//import MBCircularProgressBar


class SFCViewController: UIViewController {
    
    //    var cnt : Int = 0
    var timer: Timer?
    
    var duration = 0
     var buses: [[String: Int]] = []
    var progressWidth: Float = 1.0
    
    
    
    let settingKey = "timerValue"
    
    @IBOutlet weak var countDown: UILabel!
    
    @IBOutlet weak var nextBus: UILabel!
    
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
        getBuses()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func getBuses(){
        Alamofire.request("https://api.myjson.com/bins/11b720")
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let bus: [String: Int] = [
                        "hour": json["weekday"][0]["hour"].int!,
                        "min": json["weekday"][0]["min"].int!
                    ] // 一つの辞書を作成
                    
                    let bus1: [String: Int] = [
                        "hour": json["weekday"][0]["hour"].int!,
                        "min": json["weekday"][0]["min"].int!
                    ]
                    self.buses.append(bus)
                    self.buses.append(bus1)// 配列に入れる
                    
                }
                
                let hour = self.buses[0]["hour"]!
                let min = self.buses[0]["min"]!
                
                
                print(self.buses[0]["hour"]!)
//                let hour = self.buses["hour"]
//                let min = self.buses["min"]
//
//                var zisho:[String:String] = ["名前": "山田", "年齢": "32", "出身": "栃木"]
//                print(zisho["名前"]! + "さん")
//                let items: Dictionary<String, Int> = ["りんご": 100, "みかん": 300, "バナナ": 150]
//                if let price = items["みかん"] {
//                    print(price)    // 300
//                }
//
//                print(self.buses)
//
                
//                if let price = buses["]["hour"]{
//                    print(price)    // 30
//                }
                
                self.nextBus.text = "\(hour)時\(min)分"
        }
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

