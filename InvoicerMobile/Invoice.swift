//
//  Invoice.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Written by Brandon Roberts 4/20/15
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import Foundation

struct Invoice {
  var id : String!
  var name : String!
  var amount : NSNumber!
  var createdAt : NSDate!
  var paid : Bool!
  
  init(id: String, name: String, amount: NSNumber, createdAt: NSDate, paid: Bool) {
    self.id = id
    self.name = name
    self.amount = amount
    self.createdAt = createdAt
    self.paid = paid
  }
}