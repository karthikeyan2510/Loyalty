//
//  LYHomeDetailsWebViewVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 31/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD


class LYHomeDetailsWebViewVC: UIViewController,UIWebViewDelegate
{

    @IBOutlet weak var web_webView: UIWebView!
    var URLAddress = ""

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

    @IBAction func pressBackButton(_ sender: Any)
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
