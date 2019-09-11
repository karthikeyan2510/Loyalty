//
//  AppDelegate.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 13/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
// new code AbdulKarthi

import UIKit
import CoreData

import UserNotifications
import CoreLocation

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate
{
    
    var isLocationDenied: Bool = false
    var window: UIWindow?
    
    
    
    var dataListArray : Array<listingDataModel> =  []
    var myLocation = CLLocationCoordinate2D()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.InstanceIDTokenRefresh,
                                               object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            if #available(iOS 10.0, *)
            {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else
            {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
        })
        // pushNotificationDelgate(application:application)
        FirebaseApp.configure()
        
        return true
    }
    
    
    //************************ For FIREBASE pushNotification *******************************//
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        // print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        // print("Firebase registration token: \(fcmToken)")
        
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        
        let deviceTokenString = Messaging.messaging().fcmToken
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        
        // print("FCM token: \(deviceTokenString ?? "0000")")
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // completionHandler(UNNotificationPresentationOptions.alert)
        
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print full message.
        //   print("user info : \n\(userInfo)")
    }
    
    
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification)
    {
        if let refreshedToken = InstanceID.instanceID().token()
        {
            //  print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "deviceToken")
            UserDefaults.standard.synchronize()
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    // [END refresh_token]
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil)
            {
                //   print("Unable to connect with FCM. \(error)")
            } else {
                //  print("Connected to FCM.")
            }
        }
    }
    
    
    //************************ For NATIVE pushNotification *******************************//
    /*
     func pushNotificationDelgate(application: UIApplication)
     {
     // iOS 10 support
     if #available(iOS 10, *)
     {
     UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
     application.registerForRemoteNotifications()
     }
     // iOS 9 support
     else if #available(iOS 9, *)
     {
     UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
     UIApplication.shared.registerForRemoteNotifications()
     }
     // iOS 8 support
     else if #available(iOS 8, *)
     {
     UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
     UIApplication.shared.registerForRemoteNotifications()
     }
     // iOS 7 support
     else
     {
     application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
     }
     
     }
     
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
     {
     // Convert token to string
     let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
     
     UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
     UserDefaults.standard.synchronize()
     
     // Print it to console
     print("APNs device token: \(deviceTokenString)")
     
     }
     
     // Called when APNs failed to register the device for push notifications
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
     {
     // Print the error to console (you should alert the user that registration failed)
     print("APNs registration failed: \(error)")
     }
     
     
     func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
     // Print notification payload data
     print("Push notification received: \(data)")
     }
     
     */
    //***********************************************************************************//
    
    
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
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Loyalty")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *)
        {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        } else
        {
            // Fallback on earlier versions
        }
    }
    
}

