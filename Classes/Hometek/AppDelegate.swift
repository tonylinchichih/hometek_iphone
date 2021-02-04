//
//  AppDelegate.swift
//  Hometek
//
//  Created by Lai Lee on 08/08/2017.
//  Copyright © 2017 Lai Lee. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
//            Message ID: 0:1509731694413067%3516fede3516fede
        }
        
        if let message = userInfo["message"] {
            print("1 Message: \(message)")
            //UserInfo.sharedInstance().alertMsgs.append(message as! String)
        }
        if let aps = userInfo["aps"] {
            print("1 aps: \(aps)")
        }
        
        // Print full message.
        print(userInfo)
//        印出來的範例
//            [AnyHashable("notification_id"): 1509731694282, AnyHashable("aps"): {
//            alert =     {
//            title = "\U8b66\U544a!";
//            };
//            sound = "push.mp3";
//            }, AnyHashable("gcm.message_id"): 0:1509731694413067%3516fede3516fede]
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if let message = userInfo["message"] {
            print("Message: \(message)")
            //UserInfo.sharedInstance().alertMsgs.append(message as! String)
        }
        if let aps = userInfo["aps"] {
            print("aps: \(aps)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    var listener2: SetAsReadListener?
    class SetAsReadListener : AlertsSetAsReadResponse {
        func onSuccess() {
            print("set as read ok")
        }
        
        func onFailure(_ errorCode: Int, msg: String) {
            print("set as read fail")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
        
        if (UIApplication.shared.delegate!.window!!.rootViewController?.isKind(of: AlertsTableViewController.self))! {
            //let alertVC = UIApplication.shared.delegate!.window!!.rootViewController as! AlertsTableViewController
            //alertVC.downloadAlerts()
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            listener2 = SetAsReadListener()
            UserInfo.sharedInstance().setAsRead(listener2!)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        
        if (UIApplication.shared.delegate!.window!!.rootViewController?.isKind(of: AlertsTableViewController.self))! {
            let alertVC = UIApplication.shared.delegate!.window!!.rootViewController as! AlertsTableViewController
            alertVC.downloadAlerts()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        NotificationCenter.default.post(name: Notification.Name("applicationDidBecomeActive"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // app在前景時會呼叫
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let message = userInfo["message"] {
            print("app在前景 iOS 10 Message: \(message)")
            //UserInfo.sharedInstance().alertMsgs.append(message as! String)
            
            showAlertsScreen()
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let message = userInfo["message"] {
            print("app在背景 iOS 10 Message: \(message)")
            //UserInfo.sharedInstance().alertMsgs.append(message as! String)
            
            showAlertsScreen()
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

//收到push message之後的轉場
//https://stackoverflow.com/questions/46178870/perform-segue-from-appdelegate
//https://techenghung.wordpress.com/2016/10/03/class-note-%E8%BD%89%E5%A0%B4segue-storyboard-reference-%E8%88%87-%E8%B3%87%E6%96%99%E5%82%B3%E9%81%9E/
//
func showAlertsScreen(){
    if (UIApplication.shared.delegate!.window!!.rootViewController?.isKind(of: AlertsTableViewController.self))! {
        let alertVC = UIApplication.shared.delegate!.window!!.rootViewController as! AlertsTableViewController
        alertVC.downloadAlerts()
    } else {
        let AlertVC = UIStoryboard.getMainStoryboard().instantiateViewController(withIdentifier: "AlertsTableViewController") as! AlertsTableViewController
        UIApplication.shared.delegate!.window!!.rootViewController = AlertVC
    }
}

extension UIStoryboard{
    //returns storyboard from default bundle if bundle paased as nil.
    public class func getMainStoryboard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
