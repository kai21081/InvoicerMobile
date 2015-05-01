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
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var status: UILabel!
  @IBOutlet weak var createdAt: UILabel!
  @IBOutlet weak var amount: UILabel!
  @IBOutlet var amountTitle: UILabel!
  @IBOutlet var createdAtTitle: UILabel!
  @IBOutlet var statusTitle: UILabel!
  
  var invoice : Invoice?
  var invoiceID: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.invoice = nil
    self.invoiceID = "13"
    
    if self.invoice != nil {
      
      println("invoiceID: \(self.invoice!.id)")
      
      displayInvoice()
    }
    else if self.invoiceID != nil {
      let invoiceService = InvoiceReService()
      invoiceService.fetchInvoiceByID(self.invoiceID!, completionHandler: { [weak self] (newInvoice, error) -> () in
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          if error != nil {
            var errorAlert = UIAlertController(title: "Error", message: "An error occurred: \n\(error!)", preferredStyle: UIAlertControllerStyle.Alert)
            let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            errorAlert.addAction(confirmAction)
            self!.presentViewController(errorAlert, animated: true, completion: nil)
          }
          else if newInvoice != nil && self != nil {
            self!.invoice = newInvoice!
            self!.displayInvoice()
          }
        })
        })
    }
    
    let font = UIFont(name: "AvenirNext-Regular", size: 20.0)
    let whiteColor = UIColor.whiteColor()
    
    let labels = [status, createdAt, amount, amountTitle, createdAtTitle, statusTitle]
    for label in labels {
      label.font = font
      label.textColor = whiteColor
    }
    
    self.emailButton.tintColor = whiteColor
    self.gradientBackgroundLayer = ViewGradients.blueGradientLayerOfSize(self.view.layer.frame.size)
    self.view.layer.insertSublayer(self.gradientBackgroundLayer, atIndex: 0)
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.gradientBackgroundLayer.frame = self.view.frame
  }
  
  func displayInvoice() {
    self.navBar.title = invoice!.name
    self.amount.text = invoice!.amount.stringCurrencyValue()
    
    var dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "MM/dd/yyyy"
    self.createdAt.text = dateFormat.stringFromDate(invoice!.createdAt)
    
    if invoice!.paid == true {
      self.status.text = "Paid"
      emailButton.hidden = true
    } else {
      self.status.text = "Pending"
    }
  }

  @IBAction func emailButtonPressed(sender: AnyObject) {
    if let currentInvoice = self.invoice {
      EmailService.requestEmailFromInvoiceRe(currentInvoice.id, completionHandler: { (wasSuccess) -> () in
        if wasSuccess {
          println("Sent")
        } else {
          println("Not Sent")
        }
      })
    }
  }
}