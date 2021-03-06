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
  
  var gradientBackgroundLayer : CAGradientLayer!
  var firstTimeOnScreen = true
  
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
    
    self.gradientBackgroundLayer = ViewGradients.greenGradientLayerOfSize(self.view.layer.frame.size)
    
    self.view.layer.insertSublayer(self.gradientBackgroundLayer, atIndex: 0)
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
  
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.getInvoices()
  }
  
  override func viewWillDisappear(animated: Bool) {
    self.firstTimeOnScreen = false
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.gradientBackgroundLayer.frame = self.view.frame
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
    
    let font = UIFont(name: "AvenirNext-Bold", size: 17.0)
    sectionHeaderView.textLabel.textColor = UIColor.whiteColor()
    sectionHeaderView.textLabel.font = font
    
    let backgroundView = UIView(frame: sectionHeaderView.frame)
    let gradientLastColor = self.gradientBackgroundLayer.colors.last as! CGColor

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
    
    if self.firstTimeOnScreen == true && cell.cellHasShown == false {
      self.animateCellOnToScreen(cell)
      cell.cellHasShown = true
    }

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
  
  private func getInvoices() {
    if let stripeUserID = AppUserDefaultsService.sharedService.stripeUserID {
      InvoiceReService.fetchInvoicesForCompany(stripeUserID, completionHandler: { (returnedInvoices) -> Void in
        
        if returnedInvoices != nil {
          self.allInvoices = returnedInvoices!
        }
      })
      
    }
  }
  
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
  
  private func animateCellOnToScreen(cellToAnimate: UITableViewCell) {
    let animationDuration = 1.0

    cellToAnimate.alpha = 0.0
    cellToAnimate.transform = CGAffineTransformTranslate(cellToAnimate.transform, 0.0, -10.0)
    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      cellToAnimate.alpha = 1.0
      cellToAnimate.transform = CGAffineTransformIdentity
    })
  }
  
}
