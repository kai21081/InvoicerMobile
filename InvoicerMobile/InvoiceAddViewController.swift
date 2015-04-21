//
//  InvoiceAddViewController.swift
//  InvoicerMobile
//
//  Created by User on 2015. 4. 20..
//  Copyright (c) 2015 Craig Chaillie. All rights reserved.
//

import UIKit

class InvoiceAddViewController: AdaptiveTextFieldViewController, UITextFieldDelegate {
  
  let invoiceReDescriptionRegex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n*%$#!?,_ -]", options: nil, error: nil)
  let emailRegex = NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: nil, error: nil)
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var recipientEmailField: UITextField!
  @IBOutlet weak var amountField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.nameField.delegate = self
    self.amountField.delegate = self
    self.descriptionField.delegate = self
    self.recipientEmailField.delegate = self
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func createInvoicePressed(sender: UIButton) {
    if let
      name = self.nameField.text,
      amount = self.amountField.text,
      description = self.descriptionField.text,
      recipientEmail = self.recipientEmailField.text {
        if name == "" {
          shake(self.nameField)
        }
        else if description == "" {
          shake(self.descriptionField)
        }
        else if !validateEmail(recipientEmail) {
          shake(self.recipientEmailField)
        }
        else {
          let nf = NSNumberFormatter()
          if let validNumber = nf.numberFromString(amount) {
            let jsonInvoice = invoiceToJSON(name, description: description, amount: amount, recipient: recipientEmail)
            InvoiceReService.postInvoice(jsonInvoice, completionHandler: { (data, error) -> () in
              if error != nil {
                println(error)
              }
              else {
                println("Successfully Created and uploaded to InvoiceRe")
              }
            })
          } else {
            shake(self.amountField)
          }
        }
    }
  }
  

  @IBAction func leavePage(sender: UIButton) {
    if let vc = self.presentingViewController {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  // MARK: TextFieldDelegate
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    var isValid: Bool = true
    let range = NSMakeRange(0, count(string))
    if textField != self.amountField && textField != self.recipientEmailField {
      let matches = self.invoiceReDescriptionRegex?.numberOfMatchesInString(string, options: nil, range: range)
      if matches > 0 {
        isValid = false
      }
    }
    if !isValid {
      shake(textField)
    }
    return isValid
  }
  
  
  
  // following stolen from http://stackoverflow.com/questions/26180888/what-are-best-practices-for-validating-email-addresses-in-swift
  
  func validateEmail(candidate: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
  }

  // MARK: Create JSON Object
  
  func invoiceToJSON(name: String, description: String, amount: String, recipient: String) -> NSData {
    var error: NSError?
    var invoice = [String: String]()
    invoice["name"] = name
    invoice["description"] = description
    invoice["recipient_email"] = recipient
    invoice["amount"] = amount
    var data = NSJSONSerialization.dataWithJSONObject(invoice, options: nil, error: &error)
    return data!
  }
  
  func shake(viewToShake: UIView)
  {
    let duration = 0.25
    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
      viewToShake.transform = CGAffineTransformMakeTranslation(3, 0);
      },
      completion: {(finished) -> Void in
        viewToShake.transform = CGAffineTransformMakeTranslation(0, 0);
    })
  }
  
  
  
}
