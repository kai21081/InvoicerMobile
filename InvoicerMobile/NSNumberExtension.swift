//
//  NSNumberExtension.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/22/15.
//  Copyright (c) 2015 JHK. All rights reserved.
//

import Foundation

extension NSNumber {
  func stringCurrencyValue() -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    return numberFormatter.stringFromNumber(self)!
  }
}
