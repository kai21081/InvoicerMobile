//
//  URLParseService.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 24..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import Foundation

class URLParseService{
  class func parseURLForInvoiceID(url : NSURL) -> String?{
    var query = url.query!
    var queryArray = split(query) {$0 == "="}
    var id = queryArray[1] as String
    return id
  }
}
