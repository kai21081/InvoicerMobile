//
//  EmailService.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import Foundation

class EmailService {
  
  class func requestEmailFromInvoiceRe(invoiceID: String, completionHandler:(Bool) ->()) {
    if let stripeID = AppUserDefaultsService.sharedService.stripeUserID {
      let urlString = "https://www.invoice.re/api/v1/invoices/" + invoiceID + "/send_invoice"
      var emailRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
      emailRequest.HTTPMethod = "POST"
      emailRequest.setValue(stripeID, forHTTPHeaderField: "stripe-user-id")
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(emailRequest, completionHandler: { (data, response, error) -> Void in
        if let httpResponse = response as? NSHTTPURLResponse {
          println("\(httpResponse.statusCode)")
          if httpResponse.statusCode == 200  {
            completionHandler(true)
          } else {
            completionHandler(false)
          }
        }
      })
      dataTask.resume()
    }
  }
  
  
}