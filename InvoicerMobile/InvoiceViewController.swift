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
  
  let stripeService = StripeService()
  var gradientBackgroundLayer : CAGradientLayer!
  
  var allInvoices = [Invoice]() {
    didSet {
      self.sortInvoices(allInvoices)
      self.tableView.reloadData()
    }
  }
  var paidInvoices = [Invoice]()
  var unPaidInvoices = [Invoice]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.gradientBackgroundLayer = ViewGradients.blueGradientLayerOfSize(self.view.layer.frame.size)
    self.gradientBackgroundLayer = ViewGradients.pinkAwesomeGradientLayerOfSize(self.view.layer.frame.size)
    
    self.view.layer.insertSublayer(self.gradientBackgroundLayer, atIndex: 0)
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.stripeService.fetchInvoicesForCompany("test", completionHandler: { (returnedInvoices) -> Void in
      if returnedInvoices != nil {
        self.allInvoices = returnedInvoices!
      }
    })
  
  }
  
  //MARK:
  //MARK: UITableViewDataSource and Delegate
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Unpaid"
    case 1:
      return "Paid"
    default:
      return nil
    }
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

    // Changes text label and background of section header to match background gradient
    let sectionHeaderView = view as! UITableViewHeaderFooterView
    sectionHeaderView.textLabel.textColor = UIColor.whiteColor()
    
    let backgroundView = UIView(frame: sectionHeaderView.frame)
    let gradientLastColor = self.gradientBackgroundLayer.colors.last as! CGColorRef
    backgroundView.backgroundColor = UIColor(CGColor: gradientLastColor)
    
    sectionHeaderView.backgroundView = backgroundView
  
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return self.unPaidInvoices.count
    case 1:
      return self.paidInvoices.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var displayedInvoice : Invoice
    
    switch indexPath.section {
    case 0:
      displayedInvoice = self.unPaidInvoices[indexPath.row]
    case 1:
      displayedInvoice = self.paidInvoices[indexPath.row]
    default:
      displayedInvoice = Invoice(id: "", name: "", amount: NSNumber(), createdAt: NSDate(), paid: true)
    }

    let cell = self.tableView.dequeueReusableCellWithIdentifier("InvoiceCell") as! InvoiceCell
    
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
      let section = self.tableView.indexPathForSelectedRow()?.section
      
      switch section! {
      case 0:
        nextVC.invoice = unPaidInvoices[row!]
      case 1:
        nextVC.invoice = paidInvoices[row!]
      default:
        nextVC.invoice = nil
      }
    }
  }
  
  //MARK:
  //MARK: Private methods
  
  private func sortInvoices(invoicesToSort: [Invoice]) {
    
    self.unPaidInvoices = [Invoice]()
    self.paidInvoices = [Invoice]()
    
    for invoice in invoicesToSort {
      if invoice.paid == true {
        self.paidInvoices.append(invoice)
      } else {
        self.unPaidInvoices.append(invoice)
      }
    }

  }
  
}
