//
//  LYVentreWebsiteVC.swift
//  Loyalty
//
//  Created by CIPL0444MOBILITY on 26/10/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class LYVentreWebsiteVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var web_webView: UIWebView!
    var URLAddress = "https://VENTRE.xyz"
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if !URLAddress.isEmpty
        {
            loadingIndicator.isHidden = false
            web_webView.loadRequest(NSURLRequest(url: (NSURL(string: URLAddress))! as URL) as URLRequest)
        }
    }
    
    @IBAction func pressBackButton(_ sender: UIButton)
    {
        self.navigationController!.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView : UIWebView)
    {
        loadingIndicator.isHidden = false
    }
    func webViewDidFinishLoad(_ webView : UIWebView)
    {
        loadingIndicator.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        SharedInstance.alertview(message: error.localizedDescription as NSString)
        loadingIndicator.isHidden = false
    }
    
}
