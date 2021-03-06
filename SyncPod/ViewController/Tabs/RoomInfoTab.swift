//
//  RoomInfoTab.swift
//  SyncPod
//
//  Created by 森篤史 on 2018/01/27.
//  Copyright © 2018年 Cyder. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class RoomInfoTab: UIViewController, IndicatorInfoProvider, HttpRequestDelegate {
    var itemInfo: IndicatorInfo = "ルーム情報"
    let room = DataStore.CurrentRoom
    var shareText = ""
    var shareUrl = ""
    
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func share(_ sender: UIButton) {
        if let shareWebsite = URL(string: shareUrl) {
            let activityItems = [shareText, shareWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = DeviceConst.buttonCornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.room.key != nil) {
            let http = HttpRequestHelper(delegate: self)
            http.get(data: ["room_key": self.room.key!], endPoint: "rooms")
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func onSuccess(data: JSON) {
        self.roomName.text = data["room"]["name"].string
        self.roomDescription.text = data["room"]["description"].string
        self.shareText = "SyncPodで一緒に動画を見ませんか？\n\nルーム名: \(data["room"]["name"].string!)\nルームキー: \(data["room"]["key"].string!)\n\nこちらのURLからも入室できます。"
        self.shareUrl = "http://app.sync-pod.com/room?room_key=\(data["room"]["key"].string!)"
    }
    
    func onFailure(error: Error) {
        print(error)
    }
}

