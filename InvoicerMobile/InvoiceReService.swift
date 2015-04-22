//
//  InvoiceReService.swift
//  InvoicerMobile
//
//  Created by User on 4/21/15.
//  Copyright (c) 2015 Craig Chaillie. All rights reserved.
//

import Foundation

class InvoiceReService {
  
  
  class func postInvoice(jsonData: NSData, completionHandler:(AnyObject?, String?) -> ()) {
    let invoiceReInvoicePostURLString = "https://www.invoice.re/api/v1/invoices"
    
    let request = NSMutableURLRequest(URL: NSURL(string: invoiceReInvoicePostURLString)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        //println("Error: InvoiceReService unable to perform request. \(error)")
        completionHandler(nil, error.description)
      }
      else if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 201:
          //println("Invoice Successfully Created!")
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(data, error.description)
          })
        default:
          completionHandler(nil, "\(httpResponse.statusCode)")
        }
      }
    })
    dataTask.resume()
  }
  
  
  
}

