//
//  StripeService.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/21/15.
//  Copyright (c) 2015 Brandon Roberts. All rights reserved.
//

import Foundation

class StripeService {
  
  let localHostString = "http://127.0.0.1:3000/"
  let invoiceReApiPrefixString = "https://www.invoice.re/api/v1/"
  
  func fetchInvoicesForCompany(companyID : String, completionHandler: ([Invoice]?)->Void) {
//    let query = "?KEYS=VALUES"
//    let url = NSURL(string: localHost + query)
    
    let companyInvoiceURL = NSURL(string: invoiceReApiPrefixString + "invoices")
    
    let token = NSUserDefaults.standardUserDefaults().valueForKey(kUserDefaultsStripeTokenKey) as! String
    
    let request = NSMutableURLRequest(URL: companyInvoiceURL!)
    request.setValue(token, forHTTPHeaderField: "stripe-access-token")
    
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