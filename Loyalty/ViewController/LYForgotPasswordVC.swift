//
//  LYForgotPasswordVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 18/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD


class LYForgotPasswordVC: UIViewController
{

    @IBOutlet weak var txt_userEmail: UITextField!
    override func viewDidLoad()
    {
     super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressBackButton(_ sender: Any)
    {
        
        self.navigationController!.popViewController(animated: true)

    }

    @IBAction func pressResetButton(_ sender: Any)
    {
        if txt_userEmail.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter email-id")
        }else if !SharedInstance.isValidEmail(withemail: txt_userEmail.text!)
        {
            SharedInstance.alertview(message: "Please enter valid email-id")
        }else
            {
               resetPasswordServiceCall(mailID: txt_userEmail.text!)
               self.view.endEditing(true)

            }
    }

    // MARK: - Local Methods
    func resetPasswordServiceCall(mailID : String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let RequestParameters = ["email":mailID]
        
        WebservicesHandler.resetPasswordServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    _ = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    if result?.lowercased() == "success"
                    {
                        SharedInstance.alertview(message: messageString ?? "")
                        self.navigationController!.popViewController(animated: true)

                    }else
                    {
                        SharedInstance.alertview(message: messageString ?? "")
                    }
            }
            
        },ErrorCompletion:{(Message)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    SharedInstance.alertview(message: Message as NSString)
            }
        })
    }
    

}
