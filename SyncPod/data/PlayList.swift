//
//  PlayList.swift
//  SyncPod
//
//  Created by 森篤史 on 2018/01/29.
//  Copyright © 2018年 Cyder. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PlayListDelegate {
    func updatedPlayList()
}

class PlayList {
    private var list: [Video] = []
    var delegate: PlayListDelegate?
    
    func set(list: JSON) {
        self.list = list.arrayValue.map { Video(video: $0) }
        delegate?.updatedPlayList()
    }
    
    func get(index: Int) -> Video {
        return list[index]
    }
    
    var count:Int {
        get {
            return list.count
        }
    }
}
