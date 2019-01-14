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
        Alamofire.request("https://api.myjson.com/bins/169it4")
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let bus: [String: Int] = [
                        "hour": json["hour"].int!,
                        "min": json["min"].int!
                    ] // 一つの辞書を作成
                    
                 
                    self.buses.append(bus)
//                    print(json)
                    
                    
            
                }
                
                
                let hour = self.buses[4]["hour"]!
                let min = self.buses[4]["min"]!
                //添字を変えれば次のオブジェクトに移動してる
                
                
//                print(self.buses[0]["hour"]!)
           
                
                self.datePicker()
//
                let date = Date()
                
//                取得する要素を選択する
                let calendar = Calendar.current
                let component = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday], from: date)
                
//                let nowHour = component.hour!
//                print(self.buses)
                
            
                for (key,value) in self.buses[4] {
                    print("\(key)は\(value)円です。")
                }
                // 日時と時間の出力
//                print("西暦:"+String(component.year!))
//                print("月:"+String(component.month!))
//                print("日:"+String(component.day!))
//                print("時:"+String(component.hour!))
//                print("分:"+String(component.minute!))
//                print("秒:"+String(component.second!))
               

                
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

