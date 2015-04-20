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
  
  var invoices = [Invoice]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
  
  }
  
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
    cell.amountLabel.text = displayedInvoice.amount.stringValue
    cell.imageView?.image = UIImage(named: "\(displayedInvoice.paid)")

    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowInvoiceDetail" {
      let nextVC = segue.destinationViewController as! InvoiceDetailViewController
      // TODO: Interface with InvoiceDetail
    }
  }
  
}
