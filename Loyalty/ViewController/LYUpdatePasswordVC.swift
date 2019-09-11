//
//  LYUpdatePasswordVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 21/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import  MBProgressHUD

class LYUpdatePasswordVC: UIViewController
{
    
    @IBOutlet weak var txt_CurrentPassWord: UITextField!
    @IBOutlet weak var txt_NewPassword: UITextField!
    @IBOutlet weak var txt_ReenterNewPassword: UITextField!
    
    @IBOutlet weak var view_updatePasswordSubview: UIView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        SharedInstance.setCornerRadiusForUIButton(view: view_updatePasswordSubview)
        
        let imageArr = ["changePassword","changePassword","changePassword"]
        let array = [txt_CurrentPassWord,txt_NewPassword,txt_ReenterNewPassword]
        SharedInstance.paddingViewWithImage(textFieldArray : array as NSArray,imageArr: imageArr as NSArray)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Button Action
    
    @IBAction func pressBackButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func pressUpdatePasswordButton(_ sender: Any)
    {
        updatePassword()
    }
    
    
    // MARK: - Button Action
    func updatePassword()
    {
        let loginModel = SharedInstance.returnUserLoginDetails()
        
        if txt_CurrentPassWord.text!.isEmpty
        {
            SharedInstance.alertview(message: "Enter current password")
            
        }else if txt_CurrentPassWord.text! != "\(loginModel.oldPassword)"
        {
            SharedInstance.alertview(message: "Incorrect current password")
            
        }else if txt_NewPassword.text!.isEmpty
        {
            SharedInstance.alertview(message: "Enter new password")
            
        }else if txt_ReenterNewPassword.text!.isEmpty
        {
            SharedInstance.alertview(message: "Re-Enter new password")
            
        }else if txt_NewPassword.text! != txt_ReenterNewPassword.text!
        {
            SharedInstance.alertview(message: "Password is not matching")
        }
        else
        {
            updatePasswordServiceCall()
        }
        
    }
    
    // MARK: - Local Methods
    func updatePasswordServiceCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let loginModel = SharedInstance.returnUserLoginDetails()
        
        let RequestParameters =
            [
                "uid":loginModel.uid,
                "old_password":loginModel.oldPassword,
                "new_password":txt_NewPassword.text!
        ]
        
        WebservicesHandler.updatePasswordServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    _ = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    if result?.lowercased() == "success"
                    {
                        SharedInstance.alertview(message: messageString ?? "")
                        
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "userName")
                        defaults.removeObject(forKey: "passWord")
                        defaults.synchronize()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "LYLoginVC") as! LYLoginVC
                        let navigationController = UINavigationController(rootViewController: controller)
                        navigationController.isNavigationBarHidden = true
                        self.present(navigationController, animated: true, completion: nil)
                        
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
