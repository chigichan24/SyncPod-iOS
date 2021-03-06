//
//  AppDelegate.swift
//  SyncPod
//
//  Created by 森篤史 on 2017/11/25.
//  Copyright © 2017年 Cyder. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var roomKey: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.selectStartPage()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Override point for customization after application launch.

        self.selectStartPage(url: url)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func selectStartPage(url: URL? = nil) {
        self.roomKey = nil
        
        if(CurrentUser.userToken == nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "FirstStart", bundle: nil)
            let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "FirstStartTopView") as UIViewController
            window?.rootViewController = viewController
        } else if(url?.path == "/room") {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController: UIViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as UIViewController
            window?.rootViewController = navigationController
            if let roomKey = url!.fragments["room_key"] {
                self.roomKey = roomKey
            }
        }
    }
}

