//
//  InvoiceDetailViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceDetailViewController: UIViewController {


  @IBOutlet weak var invoiceDescription: UILabel!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var status: UILabel!
  @IBOutlet weak var createdAt: UILabel!
  @IBOutlet weak var amount: UILabel!
  
  var invoice : Invoice!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.invoiceDescription.text = invoice.name
      self.amount.text = invoice.amount.stringValue
      //self.createdAt.text = invoice.createdAt.
      if invoice.paid == true{
        self.status.text = "Paid"
        emailButton.enabled = false
      }else{
        self.status.text = "Pending"
      }

    }
    

  @IBAction func emailButtonPressed(sender: AnyObject) {
    
  }

}
