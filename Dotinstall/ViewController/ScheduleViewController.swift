////
////  ScheduleViewController.swift
////  Dotinstall
////
////  Created by satoshi on 2018/12/17.
////  Copyright © 2018年 satoshi. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//
//class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
//
//    @IBOutlet weak var MyUITableView: UITableView!
//    var buses: [[String: Int]] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        getBuses()
//        MyUITableView.dataSource = self
//        MyUITableView.delegate = self
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func getBuses(){
//        Alamofire.request("https://api.myjson.com/bins/7bdlk")
//            .responseJSON { response in
//                guard let object = response.result.value else {
//                    return
//                }
//                
//                let json = JSON(object)
//                json.forEach { (_, json) in
//                    let bus: [String: Int] = [
//                        "hour": json[0]["weekday"][0]["hour"].int!,
//                        "min": json[0]["weekday"][0]["min"].int!
//                    ] // 一つの辞書を作成
//                    
//                    
//                    
//                    //                    let bus1: [String: Int] = [
//                    //                        "hour": json[0]["weekday"][0]["hour"].int!,
//                    //                        "min": json[0]["weekday"][0]["min"].int!
//                    //                    ]
//                    self.buses.append(bus)
//                    
//                    _ = self.buses[0]["hour"]!
//                    _ = self.buses[0]["min"]!
//
//                    
//                    //                    self.buses.append(bus1)// 配列に入れる
//                    
//                }
//                
//
//        }
//    }
//    
//    
//
//
//
//}
