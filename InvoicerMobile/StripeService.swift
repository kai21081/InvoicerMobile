//
//  StripeService.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/21/15.
//  Copyright (c) 2015 Brandon Roberts. All rights reserved.
//

import Foundation

class StripeService {
  
  let localHostURL = NSURL(string: "http://127.0.0.1:3000/")!
  
  func fetchInvoicesForCompany(companyID : String, completionHandler: ([Invoice]?)->Void) {
//    let query = "?KEYS=VALUES"
//    let url = NSURL(string: localHost + query)
    
    let request = NSURLRequest(URL: localHostURL)
    
    let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        let returnedInvoices = InvoiceJSONParser.invoicesFromJSONData(data)
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(returnedInvoices)
        })
        
      } else {
        // There was an error to handle
      }
    })
    requestTask.resume()
    
  }
}