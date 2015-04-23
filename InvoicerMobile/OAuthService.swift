//
//  OAuthService.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import Foundation

class OAuthService {
  
  let kStripeBaseAuthorizeString = "https://connect.stripe.com/oauth/authorize"
  let kStripeBaseTokenString = "https://connect.stripe.com/oauth/token"
  
  func stripeAuthenticationCodeRequest() -> NSURLRequest {
    let requestString = kStripeBaseAuthorizeString + "?client_id=" + kStripeClientID + "&response_type=code"
    return NSURLRequest(URL: NSURL(string: requestString)!)
  }
  
  func parseCodeFromStripeURL(url: NSURL?) -> String? {
    if let
      validUrl = url,
      query = validUrl.query,
      range = query.rangeOfString("code=") {
        let code = query.substringFromIndex(range.endIndex)
        return code
    } else {
      return nil
    }
  }
  
  func fetchOAuthTokenUsingCode(code: String, completionHandler:(Bool, String?) ->()) {
    
    let urlString = kStripeBaseTokenString
    let request = NSMutableURLRequest(URL:NSURL(string: urlString)!)
    request.HTTPMethod = "POST"
    let parameterString = "client_secret=\(kStripeSecretKey)&grant_type=authorization_code&code=\(code)"
    let parameterData = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    request.HTTPBody = parameterData
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("\(parameterData!.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 200...299:
          if data != nil {
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              if let
                token = jsonDictionary["access_token"] as? String,
                userId = jsonDictionary["stripe_user_id"] as? String 
              {
                
                println("ID: \(userId)")
                
                AppUserDefaultsService.sharedService.stripeToken = token
                AppUserDefaultsService.sharedService.stripeUserID = userId
                
                completionHandler(true, nil)
              }
            }
          }
        case 400:
          completionHandler(false, "Error: 400-Bad Request")
        case 401:
          completionHandler(false, "Error: 401-Unauthorized")
        case 402:
          completionHandler(false, "Error: 402-Request failed")
        case 404:
          completionHandler(false, "Error: 404-Requested Token does not exist")
        case 500...599:
          completionHandler(false, "Error: Stripe server error.  Try again later")
        default:
          completionHandler(false, "Unknown Server Error in retrieving token")
        }
      }
      if error != nil {
        completionHandler(false, error.description)
      }
    })
    dataTask.resume()
  }
  
  
}

