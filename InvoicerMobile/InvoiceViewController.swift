//
//  InvoiceViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Written by Brandon Roberts 4/20/15
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  
  var invoices = [Invoice]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
  
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.invoices.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier(<#identifier: String#>)
  }
  
}
