//
//  InvoiceAddViewController.swift
//  InvoicerMobile
//
//  Created by User on 2015. 4. 20..
//  Copyright (c) 2015 Craig Chaillie. All rights reserved.
//

import UIKit

class InvoiceAddViewController: AdaptiveTextFieldViewController, UITextFieldDelegate {
  
  var backgroundGradientLayer : CAGradientLayer!
  
  let invoiceReDescriptionRegex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n*%$#!?,_ -]", options: nil, error: nil)
  let emailRegex = NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: nil, error: nil)
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var recipientEmailField: UITextField!
  @IBOutlet weak var amountField: UITextField!
  
  @IBOutlet var invoiceNameTitle: UILabel!
  @IBOutlet var invoiceRecipientEmailTitle: UILabel!
  @IBOutlet var invoiceAmountTitle: UILabel!
  @IBOutlet var invoiceDescriptionTitle: UILabel!
  @IBOutlet var invoiceDollarSign: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.nameField.delegate = self
    self.amountField.delegate = self
    self.descriptionField.delegate = self
    self.recipientEmailField.delegate = self
    
    self.backgroundGradientLayer = ViewGradients.purpleGradientLayerOfSize(self.view.layer.frame.size)
    self.view.layer.insertSublayer(self.backgroundGradientLayer, atIndex: 0)

    let labelFont = UIFont(name: "AvenirNext-Medium", size: 20.0)
    let labelColor = UIColor.whiteColor()
    let labels = [invoiceNameTitle, invoiceRecipientEmailTitle, invoiceAmountTitle, invoiceDescriptionTitle, invoiceDollarSign]
    for label in labels {
      label.font = labelFont
      label.textColor = labelColor
    }
    
    let textFieldBackgroundColor = UIColor(CGColor: self.backgroundGradientLayer.colors.first! as! CGColor)
    let textFieldFont = UIFont(name: "AvenirNext-Regular", size: 20.0)
    let textFields = [nameField, descriptionField, recipientEmailField, amountField]
    for textField in textFields {
      textField.font = textFieldFont
      textField.textColor = labelColor
      textField.backgroundColor = UIColor.invoicerPurpleColor()
    }
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.backgroundGradientLayer.frame = self.view.frame
  }
  
  @IBAction func createInvoicePressed(sender: AnyObject) {
    if let
      name = self.nameField.text,
      amount = self.amountField.text,
      description = self.descriptionField.text,
      recipientEmail = self.recipientEmailField.text {
        if name == "" {
          shake(self.nameField)
        }
        else if !validateEmail(recipientEmail) {
          shake(self.recipientEmailField)
        }
        else if amount == "" {
          shake(self.amountField)
        }
        else if description == "" {
          shake(self.descriptionField)
        }
        else {
          
          let nf = NSNumberFormatter()
          if let validNumber = nf.numberFromString(amount) {
            
            self.enterSendingMode()
            
            let jsonInvoice = invoiceToJSON(name, description: description, amount: amount, recipient: recipientEmail)
            InvoiceReService.postInvoice(jsonInvoice, completionHandler: { [weak self] (data, error) -> () in
              if error != nil && self != nil {
                
                var errorAlert = UIAlertController(title: "Error", message: "An error occurred: \n\(error!)", preferredStyle: UIAlertControllerStyle.Alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self!.presentViewController(errorAlert, animated: true, completion: nil)
              }
              else if self != nil {
                var completedAlert = UIAlertController(title: "Awesomesauce", message: "Invoice Successfully Created", preferredStyle: UIAlertControllerStyle.Alert)
                completedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self!.presentViewController(completedAlert, animated: true, completion: nil)
                self!.clearTextFields()
              }
              
              self?.exitSendingMode()
            })
          } else {
            shake(self.amountField)
          }
        }
    }
  }
  

  @IBAction func leavePage(sender: AnyObject) {
    if let vc = self.presentingViewController {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  private func enterSendingMode() {
    let barSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    barSpinner.color = UIColor.blueColor()
    barSpinner.startAnimating()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barSpinner)
  }
  
  private func exitSendingMode() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "createInvoicePressed:")
  }
    

  //MARK: UI helper methods
  
  func clearTextFields() {
    for subview in self.view.subviews {
      if (subview.isKindOfClass(UITextField))  {
        var textField = subview as! UITextField
        textField.text = ""
      }
    }
  }
  
//  func displayAlert(text: String, color: UIColor?) {
//    if color == nil {
//      self.errorLabel.textColor = UIColor.redColor()
//    }  else {
//      self.errorLabel.textColor = color
//    }
//    self.errorLabel.text = "  " + text + "  "
//    self.errorLabel.hidden = false
//  }
  
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
  
  
  
  // following regex stolen from http://stackoverflow.com/questions/26180888/what-are-best-practices-for-validating-email-addresses-in-swift
  
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
  
  func shake(viewToShake: UIView)  {
    let duration = 0.25
    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
      viewToShake.transform = CGAffineTransformMakeTranslation(3, 0);
      },
      completion: {(finished) -> Void in
        viewToShake.transform = CGAffineTransformMakeTranslation(0, 0);
    })
  }
}
