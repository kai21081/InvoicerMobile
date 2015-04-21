//
//  InvoiceJSONParser.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/20/15.
//  Copyright (c) 2015 Brandon Roberts. All rights reserved.
//

import Foundation

class InvoiceJSONParser {
  class func invoicesFromJSONData(jsonData: NSData) -> [Invoice] {
    var invoicesToReturn = [Invoice]()
    var error : NSError?
    
    if let
      root = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.allZeros, error: &error) as? [String : AnyObject],
      invoices = root["invoices"] as? [[String : AnyObject]] {
      
        for invoiceItem in invoices {
          if let
            id = invoiceItem["id"] as? NSNumber,
            name = invoiceItem["name"] as? String,
            amount = invoiceItem["amount"] as? String,
            createdAtString = invoiceItem["created_at"] as? String {
              
              let isPaid : Bool
              let paymentDate : NSDate?
              let dateFormatter = NSDateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
              
              if let paid = invoiceItem["payment"] as? [String : AnyObject] {
                // make NSDate object from paid
                if let paymentDateString = paid["created_at"] as? String {
                  paymentDate = dateFormatter.dateFromString(paymentDateString)
                } else {
                  paymentDate = nil
                }
                isPaid = true
              } else {
                paymentDate = nil
                isPaid = false
              }
              
              let createdAt = dateFormatter.dateFromString(createdAtString)
              let numberFormatter = NSNumberFormatter()
              numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
              let numberAmount = numberFormatter.numberFromString(amount)
              
              let theInvoice = Invoice(id: id.stringValue, name: name, amount: numberAmount!, createdAt: createdAt!, paid: isPaid)
              theInvoice.paymentDate = paymentDate
              invoicesToReturn.append(theInvoice)
          }
          
          
        }
        
    }
    
    
    
    return invoicesToReturn
  }
}
