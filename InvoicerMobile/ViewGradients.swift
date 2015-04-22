//
//  ViewGradients.swift
//  InvoicerMobile
//
//  Created by Brandon Roberts on 4/21/15.
//  Copyright (c) 2015 Brandon Roberts. All rights reserved.
//

import UIKit

let alphaMaxValue : CGFloat = 255

class ViewGradients {
  
  class func darkGrayGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    let uiColor1 = UIColor(
      red: 120 / alphaMaxValue,
      green: 135 / alphaMaxValue,
      blue: 150 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 57.0 / alphaMaxValue,
      green: 79.0 / alphaMaxValue,
      blue: 96.0 / alphaMaxValue,
      alpha: 1.0
    )
    
    //    let uiColor3 = UIColor(red: 0.5, green: 0.6, blue: 0.5, alpha: 1.0)
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0.0), NSNumber(float: 1.0)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
  }
  
  class func blueGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    let uiColor1 = UIColor(
      red: 52 / alphaMaxValue,
      green: 170 / alphaMaxValue,
      blue: 220 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 0 / alphaMaxValue,
      green: 122 / alphaMaxValue,
      blue: 255 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)

  }
  
  class func lightBlueGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    
    let uiColor1 = UIColor(
      red: 209 / alphaMaxValue,
      green: 238 / alphaMaxValue,
      blue: 252 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 190 / alphaMaxValue,
      green: 220 / alphaMaxValue,
      blue: 252 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
    
  }
  
  class func oceanBlueGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    let uiColor1 = UIColor(
      red: 26 / alphaMaxValue,
      green: 214 / alphaMaxValue,
      blue: 253 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 29 / alphaMaxValue,
      green: 98 / alphaMaxValue,
      blue: 240 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
  }
  
  class func purpleGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    let uiColor1 = UIColor(
      red: 198 / alphaMaxValue,
      green: 68 / alphaMaxValue,
      blue: 252 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 88 / alphaMaxValue,
      green: 86 / alphaMaxValue,
      blue: 214 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
  }
  
  class func pinkAwesomeGradientLayerOfSize(size: CGSize) -> CAGradientLayer {

    let uiColor1 = UIColor(
      red: 239 / alphaMaxValue,
      green: 77 / alphaMaxValue,
      blue: 182 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 198 / alphaMaxValue,
      green: 67 / alphaMaxValue,
      blue: 252 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
  
  }
  
  class func greenGradientLayerOfSize(size: CGSize) -> CAGradientLayer {
    let uiColor1 = UIColor(
      red: 76 / alphaMaxValue,
      green: 217 / alphaMaxValue,
      blue: 100 / alphaMaxValue,
      alpha: 1
    )
    
    let uiColor2 = UIColor(
      red: 100 / alphaMaxValue,
      green: 231 / alphaMaxValue,
      blue: 134 / alphaMaxValue,
      alpha: 1.0
    )
    
    let colors = [uiColor1.CGColor, uiColor2.CGColor]
    let locations = [NSNumber(float: 0), NSNumber(float: 1)]
    
    return self.gradientLayerOfSize(size, colors: colors, locations: locations)
  }
  
  private class func gradientLayerOfSize(size: CGSize, colors: [CGColor!], locations: [NSNumber]) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame.size = size
    gradientLayer.colors = colors
    gradientLayer.locations = locations
    
    return gradientLayer
  }
  
}
