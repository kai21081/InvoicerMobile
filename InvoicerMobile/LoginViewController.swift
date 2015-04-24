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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let gradientBackground = ViewGradients.oceanBlueGradientLayerOfSize(self.view.layer.frame.size)
    self.view.layer.insertSublayer(gradientBackground, atIndex: 0)
    
    self.loginButton.tintColor = UIColor.whiteColor()
  }
  
  
}
