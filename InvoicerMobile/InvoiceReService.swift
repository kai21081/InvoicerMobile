//
//  InvoiceReService.swift
//  InvoicerMobile
//
//  Created by User on 4/21/15.
//  Copyright (c) 2015 Craig Chaillie. All rights reserved.
//

import Foundation

class InvoiceReService {
  
  
  let localHostString = "http://127.0.0.1:3000/"
  let invoiceReApiPrefixString = "https://www.invoice.re/api/v1/"

  
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
    else {    //  need to authenticate and get user ID from Stripe
      completionHandler(nil, "Stripe user ID not found.  Request failed")
    }
  }
  
  func fetchInvoiceByID(invoiceID: String, completionHandler: (Invoice?, String?) -> ()) {

    let urlString = invoiceReApiPrefixString + "invoices/" + invoiceID
    let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, "Error: \(error)")
      }
      else if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 200...299:
          if data != nil {
            if let invoice = InvoiceJSONParser.invoiceFromJSON(data) {
              completionHandler(invoice, nil)
            }
          }
        case 400...499:
          completionHandler(nil, "Error: \(httpResponse.statusCode) Could not find Invoice")
        case 500...599:
          completionHandler(nil, "Error: Stripe server error.  Try again later")
        default:
          completionHandler(nil, "Error \(httpResponse.statusCode) Unknown Server Error in retrieving Invoice")
        }
      }
    })
    dataTask.resume()
  }
  
  class func postAPNSToken(token: String) {

    let invoiceReApiPrefixString = "https://www.invoice.re/api/v1/"
    let invoiceReApiPostfixString = "account"
    
    let tokenPostURL = NSURL(string: invoiceReApiPrefixString + invoiceReApiPostfixString)
    
    if let stripeID = AppUserDefaultsService.sharedService.stripeUserID {
      
      let json = ["company" : ["apns_device_token" : token]]
      let jsonData = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil)
      
      let request = NSMutableURLRequest(URL: tokenPostURL!)
      request.HTTPMethod = "PATCH"
      request.HTTPBody = jsonData
      request.setValue(stripeID, forHTTPHeaderField: "stripe-user-id")
      request.setValue("\(jsonData?.length)", forHTTPHeaderField: "Content-Length")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        // Not doing anything anyway
      })
      requestTask.resume()
    }
  }
  
  
  class func fetchInvoicesForCompany(companyID : String, completionHandler: ([Invoice]?)->Void) {
    
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

