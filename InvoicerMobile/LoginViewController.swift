//
//  LoginViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var logoImageView: UIImageView!
  
  let floatingAnimationDuration : NSTimeInterval = 1.3
  let dropHeight : CGFloat = 10.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let gradientBackground = ViewGradients.oceanBlueGradientLayerOfSize(self.view.layer.frame.size)
    self.view.layer.insertSublayer(gradientBackground, atIndex: 0)
    
    self.loginButton.tintColor = UIColor.whiteColor()
    
    self.animateLogo()
  }
  
  private func animateLogo() {
    
    UIView.animateWithDuration(floatingAnimationDuration, delay: 0, options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat, animations: {[weak self] () -> Void in
      
      if self != nil {
        self!.logoImageView.frame.origin.y = self!.logoImageView.frame.origin.y + self!.dropHeight
      }
      // Empty
    }, completion: nil)
    
    
    
//    UIView.animateWithDuration(floatingAnimationDuration, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {[weak self] () -> Void in
//      self.logo.frame.origin.y = self.logo.frame.origin.y + dropHeight
//    }, completion: nil)
  }
  
  
}
