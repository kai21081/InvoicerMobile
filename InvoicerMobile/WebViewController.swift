//
//  WebViewController.swift
//  InvoicerMobile
//
//  Created by User on 4/20/15.
//  Copyright (c) 2015 JHK. All rights reserved.
//

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
  
  var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView = WKWebView(frame: self.view.frame)
    self.view.addSubview(self.webView)
    self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
    constrainView(self.webView, toContainer: self.view)
    let oAuthService = OAuthService()
    let request = oAuthService.requestOAuthURL()
    self.webView.navigationDelegate = self
    self.webView.loadRequest(request)
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
    
    let invoiceVC = self.storyboard?.instantiateViewControllerWithIdentifier("InvoiceViewController") as! InvoiceViewController
    UIView.transitionFromView(self.view, toView: invoiceVC.view, duration: viewTransitionAnimationDuration, options: transitionAnimationStyle, completion: { (finished) -> Void in
      window?.rootViewController = invoiceVC
    })
  }
  
  //MARK: WKWebview Navigation Delegate
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.URL
    if let redirectString = url?.absoluteString {
      if redirectString.rangeOfString(kURLSchema) != nil {
        if let
          query = url!.query,
          range = query.rangeOfString("code=") {
            let code = query.substringFromIndex(range.endIndex)
            println(code)
            if code != "" {
              NSUserDefaults.standardUserDefaults().setObject(code, forKey: kUserDefaultsStripeTokenKey)
              transitionToInvoiceViewController()
            }
        }
        
        
      }
    }
    decisionHandler(WKNavigationActionPolicy.Allow)
    
  }

}
