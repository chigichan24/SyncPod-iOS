//
//  PlayListTab.swift
//  SyncPod
//
//  Created by 森篤史 on 2018/01/27.
//  Copyright © 2018年 Cyder. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlayListTab: UIViewController, IndicatorInfoProvider, VideoDataDelegate, PlayListDelegate, UITableViewDataSource, UITableViewDelegate {
    var itemInfo: IndicatorInfo = "プレイリスト"
    let nowPlayingVideo = DataStore.CurrentRoom.nowPlayingVideo
    let playList = DataStore.CurrentRoom.playList

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var nowPlayingVideoTitle: UILabel!
    @IBOutlet weak var nowPlayingVideoChannel: UILabel!
    @IBOutlet weak var nowPlayingVideoInfo: UILabel!
    @IBOutlet weak var nowPlaingVideoView: UIView!

    override func viewDidLoad() {
        nowPlayingVideo.delegate = self
        playList.delegate = self
        self.TableView.translatesAutoresizingMaskIntoConstraints = true
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    func updatedVideoData() {
        if nowPlayingVideo.video != nil {
            nowPlaingVideoView.isHidden = false
            nowPlayingVideoTitle.text = nowPlayingVideo.video?.title
            nowPlayingVideoChannel.text = nowPlayingVideo.video?.channelTitle
            let published = nowPlayingVideo.video?.published ?? ""
            let viewCount = nowPlayingVideo.video?.viewCountString ?? "0"
            nowPlayingVideoInfo.text = "公開: " + published + " 視聴回数: " + viewCount + " 回"
        } else {
            nowPlaingVideoView.isHidden = true
        }
    }

    func updatedPlayList() {
        print("update chat list")
        self.TableView.reloadData()
        self.TableView.layoutIfNeeded()
        self.TableView.frame = CGRect(x: TableView.frame.origin.x,
            y: TableView.frame.origin.y,
            width: TableView.superview!.frame.width,
            height: TableView.contentSize.height)
    }

    //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat", for: indexPath as IndexPath) as! VideoTableViewCell
        cell.setCell(video: playList.get(index: indexPath.row))
        return cell
    }

    //データの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList.count
    }
}
