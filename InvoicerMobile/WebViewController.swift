//
//  WebViewController.swift
//  InvoicerMobile
//
//  Created by User on 4/20/15.
//  Copyright (c) 2015 Craig Chaillie. All rights reserved.
//

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
  
  var webView: WKWebView!
  let oAuthService = OAuthService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView = WKWebView(frame: self.view.frame)
    self.view.addSubview(self.webView)
    self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
    constrainView(self.webView, toContainer: self.view)
    self.webView.navigationDelegate = self
    let request = self.oAuthService.stripeAuthenticationCodeRequest()
    self.webView.loadRequest(request)
  }
  
  
  //MARK: WKWebview Navigation Delegate
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.URL
    if let redirectString = url?.absoluteString {
      if redirectString.rangeOfString(kURLSchema) != nil {
        let code = self.oAuthService.parseCodeFromStripeURL(url)
        if code != "" && code != nil {
          self.oAuthService.fetchOAuthTokenUsingCode(code!, completionHandler: { (token, error) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ [weak self] () -> Void in
              if token != nil && self != nil {
                NSUserDefaults.standardUserDefaults().setObject(token, forKey: kUserDefaultsStripeTokenKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                self!.transitionToInvoiceViewController()
              } else {
                
                
                // implement something to display error
                
                println(error)
              }
            })
          })
        }
      }
    }
    decisionHandler(WKNavigationActionPolicy.Allow)
  }
  
  

  func constrainView(child: UIView, toContainer container: UIView) {
    var top = NSLayoutConstraint(item: child, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: container, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
    container.addConstraint(top)
    var bottom = NSLayoutConstraint(item: child, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem:
      container, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: 0)
    container.addConstraint(bottom)
    var left = NSLayoutConstraint(item: child, attribute: .LeadingMargin, relatedBy: .Equal, toItem: container, attribute: .Leading, multiplier: 1.0, constant: 0.0)
    container.addConstraint(left)
    var right = NSLayoutConstraint(item: child, attribute: .TrailingMargin, relatedBy: .Equal, toItem: container, attribute: .Trailing, multiplier: 1.0, constant: 0)
    container.addConstraint(right)
  }

  
  func transitionToInvoiceViewController() {
    
    let viewTransitionAnimationDuration: Double = 0.5
    let transitionAnimationStyle = UIViewAnimationOptions.TransitionFlipFromBottom
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let window = appDelegate.window
    
    let invoiceVC = self.storyboard?.instantiateViewControllerWithIdentifier("InvoiceNavController") as! UINavigationController
    UIView.transitionFromView(self.view, toView: invoiceVC.view, duration: viewTransitionAnimationDuration, options: transitionAnimationStyle, completion: { (finished) -> Void in
      window?.rootViewController = invoiceVC
    })
  }
  
}
