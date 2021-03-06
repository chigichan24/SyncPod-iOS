//
//  TopViewController.swift
//  SyncPod
//
//  Created by 森篤史 on 2018/01/18.
//  Copyright © 2018年 Cyder. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopViewController: UIViewController, HttpRequestDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var JoinRoomPanel: UIView!
    @IBOutlet weak var CreateRoomPanel: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var ScrillView: UIScrollView!

    var joinedRooms: JSON = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        //ナビゲーションアイテムのタイトルに画像を設定する。
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "title"))

        //タッチ制御
        let joinRoomTap = UITapGestureRecognizer(target: self, action: #selector(TopViewController.showJoinRoomAlert(_:)))
        self.JoinRoomPanel.addGestureRecognizer(joinRoomTap)
        
        let createRoomTap = UITapGestureRecognizer(target: self, action: #selector(TopViewController.createRoom(_:)))
        self.CreateRoomPanel.addGestureRecognizer(createRoomTap)

        self.TableView.translatesAutoresizingMaskIntoConstraints = true
        
        //引っ張って更新
        self.ScrillView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(TopViewController.refresh(sender:)), for: .valueChanged)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let roomKey = appDelegate.roomKey {
            self.joinRoom(roomKey: roomKey)
            appDelegate.roomKey = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //最近入室したルームの取得
        let Http = HttpRequestHelper(delegate: self)
        Http.get(data: nil, endPoint: "joined_rooms")
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        //最近入室したルームの取得
        let Http = HttpRequestHelper(delegate: self)
        Http.get(data: nil, endPoint: "joined_rooms")
        self.TableView.translatesAutoresizingMaskIntoConstraints = true
    }

    @objc func showJoinRoomAlert(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "ルームに参加する", message: "ルームキーを入力して下さい。", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.default)
        let defaultAction = UIAlertAction(title: "送信", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            let textFields: Array<UITextField>? = alert.textFields as Array<UITextField>?
            let roomKey: String = textFields![0].text!
            self.joinRoom(roomKey: roomKey)
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addTextField(configurationHandler: { (text: UITextField!) -> Void in
            text.placeholder = "ルームキー"
        })
        present(alert, animated: true)
    }
    
    func joinRoom(roomKey: String) {
        self.performSegue(withIdentifier: "JoinRoomSegue", sender: roomKey)
    }
    
    @objc func createRoom(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "CreateRoomSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinRoomSegue" {
            let roomViewController = segue.destination as! RoomViewController
            roomViewController.roomKey = sender as! String
        }
    }

    func onSuccess(data: JSON) {
        print(data)
        refreshControl.endRefreshing()
        joinedRooms = data["joined_rooms"]
        self.TableView.reloadData()
        self.TableView.layoutIfNeeded()
        self.TableView.frame = CGRect(x: TableView.frame.origin.x,
            y: TableView.frame.origin.y,
            width: TableView.superview!.frame.width,
            height: TableView.contentSize.height)
    }

    func onFailure(error: Error) {
        print(error)
    }

    //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Room", for: indexPath as IndexPath) as! JoinedRoomsTabledViewCell
        cell.setCell(room: joinedRooms[indexPath.row])
        return cell
    }

    //データの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedRooms.count
    }

    //タッチされた時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.joinRoom(roomKey: joinedRooms[indexPath.row]["key"].string!)
    }
}
