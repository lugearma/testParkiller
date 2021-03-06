//
//  AppDelegate.swift
//  testParkiller
//
//  Created by Luis Arias on 05/08/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let apiKey = "AIzaSyB-B70WKJN7Jc8oa5M7BOS4SNzPElSjq80"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        GMSServices.provideAPIKey(self.apiKey)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        //Shows an alert if the app is in foreground
        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        if let message = notification.alertBody{
            let alert = UIAlertController(title: "New Zone", message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default){ _ in }
            alert.addAction(action)
            
            rootVC?.presentViewController(alert, animated: true, completion: nil)
        }
    }


}

