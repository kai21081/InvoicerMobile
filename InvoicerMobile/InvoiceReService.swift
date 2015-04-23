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
    
    if let stripeID = AppUserDefaultsService.sharedService.stripeUserID {
      
      let request = NSMutableURLRequest(URL: NSURL(string: invoiceReInvoicePostURLString)!)
      request.HTTPMethod = "POST"
      request.HTTPBody = jsonData
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      
     // request.setValue(token, forHTTPHeaderField: "stripe-access-token")
      request.setValue(stripeID, forHTTPHeaderField: "stripe-user-id")
      request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        if error != nil {
          //println("Error: InvoiceReService unable to perform request. \(error)")
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(nil, error.description)
          })
        }
        else if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 201:
            //println("Invoice Successfully Created!")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(data, nil)
            })
          default:
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(nil, "\(httpResponse.statusCode)")
            })
          }
        }
      })
      dataTask.resume()
    }
  }
  
  class func postAPNSToken(token: String) {
    //TODO: Still being implemented
    let invoiceReApiPrefixString = "https://www.invoice.re/api/v1/"
    let invoiceReApiPostfixString = ""
    
    let tokenPostURL = NSURL(string: invoiceReApiPrefixString + invoiceReApiPostfixString)
    
    let request = NSMutableURLRequest(URL: tokenPostURL!)
    
    let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
    })
    requestTask.resume()

    
    
    
  }
  
  
  class func fetchInvoicesForCompany(companyID : String, completionHandler: ([Invoice]?)->Void) {
    //    let query = "?KEYS=VALUES"
    //    let url = NSURL(string: localHost + query)
    let localHostString = "http://127.0.0.1:3000/"
    let invoiceReApiPrefixString = "https://www.invoice.re/api/v1/"
    
    let companyInvoiceURL = NSURL(string: invoiceReApiPrefixString + "invoices")
    
    let request = NSMutableURLRequest(URL: companyInvoiceURL!)
        request.setValue(companyID, forHTTPHeaderField: "stripe-user-id")
    
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

