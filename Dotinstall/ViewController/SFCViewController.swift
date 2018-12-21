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
                let now = NSDate()
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                
                let string = formatter.string(from: now as Date)
                
                print(string)
                self.datePicker()
               

                
                self.nextBus.text = "次のバスは\(hour)時\(min)分"
        }
    }
    
    func datePicker(){
        let comp = Calendar.Component.weekday
        let weekday = NSCalendar.current.component(comp, from: NSDate() as Date)
        
        if weekday < 5 {
            print("今日は平日です")
            //平日のタイムテーブルから取得
            
        } else if weekday >=  5{
            print("今日は週末です")
            //週末のタイムテーブルから取得
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

