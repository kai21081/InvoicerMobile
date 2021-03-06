//
//  PayViewController.swift
//  InvoicerMobile
//
//  Created by Jisoo Hong on 2015. 4. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, STPCheckoutViewControllerDelegate {

  @IBOutlet weak var invoiceAmt: UILabel!
  @IBOutlet weak var invoiceCreateAt: UILabel!
  var invoice : Invoice!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      invoiceAmt.text = invoice.amount.stringCurrencyValue()
      var dateFormat = NSDateFormatter()
      dateFormat.dateFormat = "MM/dd/yyyy"
      invoiceCreateAt.text = dateFormat.stringFromDate(invoice.createdAt)

        // Do any additional setup after loading the view.
    }

  
  @IBAction func applePayButtonPressed(sender: AnyObject) {
    
    var request = Stripe.paymentRequestWithMerchantIdentifier("merchant.com.invoicereMobile")
    let label = self.invoice.name
    let amount = NSDecimalNumber(string: self.invoice.amount.stringCurrencyValue())
    request.paymentSummaryItems = [PKPaymentSummaryItem(label: label, amount: amount)]
    
    if Stripe.canSubmitPaymentRequest(request){
      //DEBUG
      var paymentController = STPTestPaymentAuthorizationViewController(paymentRequest: request)      
      paymentController.delegate = self
      
      self.presentViewController(paymentController, animated: true, completion: nil)
    }
  }
  
  @IBAction func cardPayButtonPressed(sender: AnyObject) {
    
    var options = STPCheckoutOptions()
    options.publishableKey = STPAPIClient.sharedClient().publishableKey
    options.purchaseDescription = self.invoice.name;
    options.purchaseAmount = UInt(self.invoice.amount.intValue) * 100; // this is in cents
    options.logoColor = UIColor.purpleColor();
    var checkoutViewController = STPCheckoutViewController(options: options)
    checkoutViewController.checkoutDelegate = self;
    self.presentViewController(checkoutViewController, animated: true, completion: nil)
    
  }
  
  func checkoutController(controller: STPCheckoutViewController!, didCreateToken token: STPToken!, completion: STPTokenSubmissionHandler!) {
    self.createBackendChargeWithTokenForCard(token, completion: completion)
  }
  
  func createBackendChargeWithTokenForCard(token : STPToken, completion : STPTokenSubmissionHandler){
    //Debug - generating fake invoice
//    var invoice = Invoice(id: "0101010101", name: "Code Fellows Deposit", amount: NSNumber(float: 1000.00), createdAt: NSDate(), paid: false)
    var url = NSURL(string: "https://www.invoice.re/api/v1/invoices/"+"\(self.invoice.id)"+"/payment") //?stripeToken="+"\(token.tokenId)")
    var request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    let tokenJson = self.tokenToJSON("\(token.tokenId)")
    
    
    request.HTTPBody = tokenJson
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    // request.setValue(token, forHTTPHeaderField: "stripe-access-token")
    request.setValue("\(tokenJson.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    
    
   // request.setValue("\(token.tokenId)", forHTTPHeaderField: "stripeToken")
    
    var dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil{
        completion(STPBackendChargeResult.Failure, error)
      }else{
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          if let httpResponse = response as? NSHTTPURLResponse{
            var e = NSError()
            switch httpResponse.statusCode{
            case 200...299:
              println("YESSSSSSSSSSSSSSSSS")
              completion(STPBackendChargeResult.Success, nil)
            case 400...499:
              println("Try Again: \(httpResponse.statusCode)")
              completion(STPBackendChargeResult.Failure,e)
            default:
              println("Try Again: Error \(httpResponse.statusCode)")
              completion(STPBackendChargeResult.Failure,e)
            }
          }
        })
      }
    })
    dataTask.resume()

  }

  
  func checkoutController(controller: STPCheckoutViewController!, didFinishWithStatus status: STPPaymentStatus, error: NSError) {
    switch (status) {
    case STPPaymentStatus.Success:
      self.paymentSucceeded()
      break;
    case STPPaymentStatus.Error:
      self.paymentError(error)
      break;
    case STPPaymentStatus.UserCancelled:
      // do nothing
      break;
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func paymentSucceeded(){
    let alertView = UIAlertView(title: "Success", message: "Payment Successfully Created", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
    alertView.show()
  }
  
  func paymentError(error : NSError){
    let alertView = UIAlertView(title: nil, message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
    alertView.show()
  }
  func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
    
      var card = STPCard()
      card.number = payment.stp_testCardNumber
      card.expMonth = 12
      card.expYear = 2020
      card.cvc = "123"
      STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) -> Void in
        if error != nil{
          completion(PKPaymentAuthorizationStatus.Failure)
        }else{
          println(token)
          self.createBackendChargeWithToken(token, completion: completion)
        }
      })
  
  }
  
  func createBackendChargeWithToken(token : STPToken, completion:(PKPaymentAuthorizationStatus) -> (Void)) {
    
    //Debug - generating fake invoice
//    var invoice = Invoice(id: "0101010101", name: "Code Fellows Deposit", amount: NSNumber(float: 1000.00), createdAt: NSDate(), paid: false)
    var url = NSURL(string: "https://www.invoice.re/api/v1/invoices/"+"\(self.invoice.id)"+"/payment?stripeToken="+"\(token.tokenId)")
    var request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    
    var dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil{
        completion(PKPaymentAuthorizationStatus.Failure)
      }else{
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          if let httpResponse = response as? NSHTTPURLResponse{
            switch httpResponse.statusCode{
            case 200...299:
              println("YESSSSSSSSSSSSSSSSS")
              completion(PKPaymentAuthorizationStatus.Success)
            case 400...499:
              println("Try Again: 400...499")
              completion(PKPaymentAuthorizationStatus.Failure)
            default:
              println("Try Again")
              completion(PKPaymentAuthorizationStatus.Failure)
            }
          }
        })
      }
    })
    dataTask.resume()
  }
  
  func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  func tokenToJSON(token: String) -> NSData {
    var error: NSError?
    var tokenInfo = [String: String]()
    tokenInfo["stripeToken"] = token
    var data = NSJSONSerialization.dataWithJSONObject(tokenInfo, options: nil, error: &error)
    return data!
  }
  

}
