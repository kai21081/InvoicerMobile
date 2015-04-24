//
//  InvoiceCell.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Written by Brandon Roberts 4/20/15
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceCell: UITableViewCell {
  
  var cellHasShown = false
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var amountLabel: UILabel!

  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Clear label text from storyboard
    self.nameLabel.text = nil
    self.amountLabel.text = nil
    
    // Make color changes
    let font = UIFont(name: "AvenirNext-Regular", size: 17.0)
    let white = UIColor.whiteColor()
    self.nameLabel.textColor = white
    self.amountLabel.textColor = white
  }
  
}
