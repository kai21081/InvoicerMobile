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
    Stripe.setDefaultPublishableKey(kStripePublishableKey)
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
    // following algorithm taken from Sascha's answer at  http://stackoverflow.com/questions/9372815/how-can-i-convert-my-device-token-nsdata-into-an-nsstring
  
    let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
    var tokenString = ""
    for var i = 0; i < deviceToken.length; i++ {
      tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    println("tokenString: \(tokenString)")
    AppUserDefaultsService.sharedService.pushNotificationToken = tokenString
    InvoiceReService.postAPNSToken(tokenString)
    
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    if let
      aps = userInfo["aps"] as? [String: AnyObject],
      actions = aps["actions"] as? [String: AnyObject],
      invoiceID = actions["invoice_id"] as? String,
      rootViewController = self.window?.rootViewController as? UINavigationController,
      storyboard = rootViewController.storyboard
    {
      var invoiceVC = storyboard.instantiateViewControllerWithIdentifier("InvoiceDetailViewController") as! InvoiceDetailViewController
      invoiceVC.invoice = nil
      invoiceVC.invoiceID = invoiceID
      rootViewController.pushViewController(invoiceVC, animated: true)
    }
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
      //rootViewController = self.window?.rootViewController as? LoginViewController,
    if let invoiceID = URLParseService.parseURLForInvoiceID(url){
    let invoiceService = InvoiceReService()
    invoiceService.fetchInvoiceByID(invoiceID, completionHandler: { [weak self] (newInvoice, error) -> () in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
      let storyboard = self!.window?.rootViewController!.storyboard
        if error != nil {
//          var errorAlert = UIAlertController(title: "Error", message: "An error occurred: \n\(error!)", preferredStyle: UIAlertControllerStyle.Alert)
//          self!.presentViewController(errorAlert, animated: true, completion: nil)
        }
        else if newInvoice != nil{
          if let invoice = newInvoice {
            if invoice.paid == true {
              let invoiceVC = storyboard!.instantiateViewControllerWithIdentifier("InvoiceDetailViewController") as! InvoiceDetailViewController
              invoiceVC.invoice = invoice
              self!.window?.rootViewController = invoiceVC
            }else{
              let payVC = storyboard!.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
              payVC.invoice = invoice
              self!.window?.rootViewController = payVC
            }
          }
        }
      })
      })
    }
    println(url)
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


}

