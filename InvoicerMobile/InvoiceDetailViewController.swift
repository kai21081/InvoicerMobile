//
//  InvoiceDetailViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceDetailViewController: UIViewController {

  var gradientBackgroundLayer : CAGradientLayer!

  @IBOutlet var navBar: UINavigationItem!
  @IBOutlet weak var invoiceDescription: UILabel!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var status: UILabel!
  @IBOutlet weak var createdAt: UILabel!
  @IBOutlet weak var amount: UILabel!
  
  var invoice : Invoice!
  
    override func viewDidLoad() {
        super.viewDidLoad()
            
      self.invoiceDescription.text = invoice.name

      self.navBar.title = invoice.name
      
      self.amount.text = invoice.amount.stringCurrencyValue()
      
      var dateFormat = NSDateFormatter()
      dateFormat.dateFormat = "MM/dd/yyyy"
      self.createdAt.text = dateFormat.stringFromDate(invoice.createdAt)
      
      if invoice.paid == true {
        self.status.text = "Paid"
        emailButton.hidden = true
      } else {
        self.status.text = "Pending"
      }
      
      self.gradientBackgroundLayer = ViewGradients.blueGradientLayerOfSize(self.view.layer.frame.size)
      
      self.view.layer.insertSublayer(self.gradientBackgroundLayer, atIndex: 0)

  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.gradientBackgroundLayer.frame = self.view.frame
  }

  @IBAction func emailButtonPressed(sender: AnyObject) {
    
  }

}
