//
//  OAuthService.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class OAuthService {
  
  let oAuthUrlString = "https://connect.stripe.com/oauth/authorize"
  
  func requestOAuthURL() -> NSURLRequest {
    let requestURLString = self.oAuthUrlString + "?client_id=" + kStripeClientID + "&response_type=code"
    return NSURLRequest(URL: NSURL(string: requestURLString)!)
  }
  
}