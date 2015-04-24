//
//  CardPaymentViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 23..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class CardPaymentViewController: UIViewController,PTKViewDelegate {

  @IBOutlet weak var saveButton: UIButton!
  weak var paymentView : PTKView!
    override func viewDidLoad() {
        super.viewDidLoad()
      paymentView = PTKView(frame: CGRect(x: 15, y: 20, width: 290, height: 55))
      self.paymentView.delegate = self
      self.view.addSubview(self.paymentView)
        // Do any additional setup after loading the view.
    }
  
  func paymentView(paymentView: PTKView!, withCard card: PTKCard!, isValid valid: Bool) {
    self.saveButton.enabled = valid
  }

}
