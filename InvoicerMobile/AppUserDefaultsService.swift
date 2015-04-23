//
//  AppUserDefaultsService.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/23/15.
//  Copyright (c) 2015 JHK. All rights reserved.
//

import Foundation

class AppUserDefaultsService {
  
  static let sharedService = AppUserDefaultsService()
  
  //MARK:
  //MARK: Private keys
  private let standardDefaults = NSUserDefaults.standardUserDefaults()
  private let kUserDefaultsStripeTokenKey = "StripeToken"
  private let kUserDefaultsStripeUserIdKey = "StripeUserID"
  private let kUserDefaultsPushNotificationTokenKey = "NotificationToken"

  
  //MARK:
  //MARK: Variables with get/set
  var stripeToken : String? {
    get {
      if let token = standardDefaults.valueForKey(kUserDefaultsStripeTokenKey) as? String {
        return token
      } else {
        println("No stripe token found")
        return nil
      }
    }
    
    set(newStripeToken) {
      standardDefaults.setValue(newStripeToken, forKey: kUserDefaultsStripeTokenKey)
      standardDefaults.synchronize()
    }
  }
  
  var stripeUserID : String? {
    get {
      if let userID = standardDefaults.valueForKey(kUserDefaultsStripeUserIdKey) as? String {
        return userID
      } else {
        println("No stripe user ID found")
        return nil
      }
    }
    
    set(newStripeUserID) {
      standardDefaults.setValue(newStripeUserID, forKey: kUserDefaultsStripeUserIdKey)
      standardDefaults.synchronize()
    }
  }

  var pushNotificationToken : String? {
    get {
      if let apnsToken = standardDefaults.valueForKey(kUserDefaultsPushNotificationTokenKey) as? String {
        return apnsToken
      } else {
        println("No push notification token found")
        return nil
      }
    }
    
    set(newPushNotificationToken) {
      standardDefaults.setValue(newPushNotificationToken, forKey: kUserDefaultsPushNotificationTokenKey)
      standardDefaults.synchronize()
    }
  }
}
