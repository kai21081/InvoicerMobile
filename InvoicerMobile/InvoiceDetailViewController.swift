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
  
  var invoice : Invoice?
  var invoiceID: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.invoice != nil {
      displayInvoice()
    }
    else if self.invoiceID != nil {
      let invoiceService = InvoiceReService()
      invoiceService.fetchInvoiceByID(self.invoiceID!, completionHandler: { [weak self] (newInvoice, error) -> () in
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          if error != nil {
            var errorAlert = UIAlertController(title: "Error", message: "An error occurred: \n\(error!)", preferredStyle: UIAlertControllerStyle.Alert)
            self!.presentViewController(errorAlert, animated: true, completion: nil)
          }
          else if newInvoice != nil && self != nil {
            self!.invoice = newInvoice!
            self!.displayInvoice()
          }
        })
        })
    }
    
    self.gradientBackgroundLayer = ViewGradients.blueGradientLayerOfSize(self.view.layer.frame.size)
    self.view.layer.insertSublayer(self.gradientBackgroundLayer, atIndex: 0)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.gradientBackgroundLayer.frame = self.view.frame
  }
  
  func displayInvoice() {
    self.invoiceDescription.text = invoice!.name
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
    
  }

}
