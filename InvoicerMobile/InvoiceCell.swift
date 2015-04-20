//
//  InvoiceCell.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class InvoiceCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var amountLabel: UILabel!
  @IBOutlet var invoicePaidIndicatorView: UIImageView!

  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Clear label text from storyboard
    self.nameLabel.text = nil
    self.amountLabel.text = nil
    self.invoicePaidIndicatorView.image = nil
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
