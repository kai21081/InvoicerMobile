//
//  UIColorExtension.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/21/15.
//  Copyright (c) 2015 JHK. All rights reserved.
//

import UIKit

extension UIColor {
  
  class func invoicerPurpleColor() -> UIColor {
    let alphaMaxValue :CGFloat = 255.0
    
    let uiColor = UIColor(
      red: 221 / alphaMaxValue,
      green: 153 / alphaMaxValue,
      blue: 255 / alphaMaxValue,
      alpha: 1.0
    )
    
    return uiColor
  }
  
  // Can't get RANGE to work in Swift
  
//  class func colorWithHexString(hexString: String) -> UIColor? {
//    
//    var cString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
//    
//    if (count(cString) != 6) { return nil }
//    
//    if (cString.hasPrefix("0X") || cString.hasPrefix("0x")) {
//      cString = cString.substringFromIndex(advance(cString.startIndex, 2))
//    }
//    
////    let range = NSMakeRange(0, 2)
//    
//    var range = Range(start:cString.startIndex,end:cString.endIndex)
//    let rString = cString.substringWithRange(range)
//
//    
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    NSString *rString = [cString substringWithRange:range];
//    
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    
//    return [UIColor colorWithRed:((float) r / 255.0f)
//      green:((float) g / 255.0f)
//      blue:((float) b / 255.0f)
//      alpha:1.0f];
//  }

}
