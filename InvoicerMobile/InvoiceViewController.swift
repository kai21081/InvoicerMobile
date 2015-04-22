//
//  InvoiceViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Written by Brandon Roberts 4/20/15
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  var invoices = [Invoice]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  let stripeService = StripeService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.view.layer.insertSublayer(ViewGradients.pinkAwesomeGradientLayerOfSize(self.view.layer.frame.size), atIndex: 0)
//        self.view.layer.insertSublayer(ViewGradients.oceanBlueGradientLayerOfSize(self.view.layer.frame.size), atIndex: 0)
//    self.view.layer.insertSublayer(ViewGradients.purpleGradientLayerOfSize(self.view.layer.frame.size), atIndex: 0)
    self.view.layer.insertSublayer(ViewGradients.blueGradientLayerOfSize(self.view.layer.frame.size), atIndex: 0)
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.stripeService.fetchInvoicesForCompany("test", completionHandler: { (returnedInvoices) -> Void in
      if returnedInvoices != nil {
        self.invoices = returnedInvoices!
      }
    })
  
  }
  
  //MARK:
  //MARK: UITableViewDataSource and Delegate
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.invoices.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = self.tableView.dequeueReusableCellWithIdentifier("InvoiceCell") as! InvoiceCell
    let displayedInvoice = self.invoices[indexPath.row]
    
    // Clear out the stored values just in case
    cell.nameLabel.text = nil
    cell.amountLabel.text = nil
    cell.imageView?.image = nil
    
    // Set the displayed values
    cell.nameLabel.text = displayedInvoice.name
    cell.amountLabel.text = displayedInvoice.amount.stringCurrencyValue()
    cell.imageView?.image = UIImage(named: "\(displayedInvoice.paid)")

    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  //MARK:
  //MARK: Segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowInvoiceDetail" {
      let nextVC = segue.destinationViewController as! InvoiceDetailViewController
      // TODO: Interface with InvoiceDetail
      let row = self.tableView.indexPathForSelectedRow()?.row
      nextVC.invoice = invoices[row!]
    }
  }
  
  //MARK:
  //MARK: Private methods
  

  
}
