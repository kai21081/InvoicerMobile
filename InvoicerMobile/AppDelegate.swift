//
//  AppDelegate.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    //Push Notification Registration
    let types: UIUserNotificationType = UIUserNotificationType.Badge |
      UIUserNotificationType.Sound | UIUserNotificationType.Alert
    let notificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    UIApplication.sharedApplication().registerForRemoteNotifications()

    //bypass login if Stripe Token present
    if let
      stripeToken = AppUserDefaultsService.sharedService.stripeToken,
      rootViewController = self.window?.rootViewController as? LoginViewController,
      storyboard = rootViewController.storyboard
    {
      let invoiceVC = storyboard.instantiateViewControllerWithIdentifier("InvoiceNavController") as! UINavigationController
      window?.rootViewController = invoiceVC
    }
    
    // Change appearance of all labels in the app to use a custom color
//    UILabel.appearance().textColor = UIColor.whiteColor()
    
    
    return true
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    if let token = NSString(data: deviceToken, encoding: NSASCIIStringEncoding) {
      AppUserDefaultsService.sharedService.pushNotificationToken = token as String
    }
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


}

