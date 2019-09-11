//
//  LYSignUpVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 17/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD


class LYSignUpVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    let defaults = UserDefaults.standard

    @IBOutlet weak var view_MainView: UIView!
    @IBOutlet weak var img_ProfileImage: UIImageView!
    @IBOutlet weak var btn_profileImage: UIButton!

    @IBOutlet weak var txt_userName: UITextField!
    @IBOutlet weak var txt_fullName: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmPassWord: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_zipCode: UITextField!
    @IBOutlet weak var txt_phoneNo: UITextField!
    
    var imagePicker = UIImagePickerController()
    var base64ImageString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        SharedInstance.setCornerRadiusForTextField(view:view_MainView)
        SharedInstance.setCornerRadiusForUIButton(view:view_MainView)
        SharedInstance.setCornerRadiusForUIImageView(Imageview: img_ProfileImage)
        
        txt_phoneNo.delegate = self
        txt_zipCode.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressChooseImageButton(_ sender: Any)
    {
        
        let actionSheetController = UIAlertController(title: "", message: "Option to select", preferredStyle: .actionSheet)
        
        
        let cameraActionButton = UIAlertAction(title: "Camera", style: .default)
        { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }else
            {
                SharedInstance.alertview(message: "Sorry! camera not support on your phone")
            }
            
        }
        actionSheetController.addAction(cameraActionButton)
        
        let libraryActionButton = UIAlertAction(title: "Photo Library", style: .default)
        { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(libraryActionButton)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
        
    }
    @IBAction func pressSignUPButton(_ sender: Any)
    {
        signUPMethod()
    }
    @IBAction func pressBackButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
   // MARK: - imagePickerController Delegate
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.img_ProfileImage.image = pickedImage
            let finalImage = SharedInstance.resizeImage(image : pickedImage)
            base64ImageString = SharedInstance.convertImageToBase64(image:finalImage)
        }
        
        dismiss(animated: true, completion: nil)
        
    }

   // MARK: - textField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txt_zipCode
        {
            let length = getLength(mobileNumber: textField.text!)
            
            if length == 5
            {
                if range.length == 0
                {
                    return false
                }
            }
        }
        else if textField == txt_phoneNo
        {
            let length = getLength(mobileNumber: textField.text!)
            
            if length == 10
            {
                
                if range.length == 0
                {
                    return false
                }
            }
           else if length == 3
            {
                
                let number = removeCharecterAtLast(number: textField.text!)
                
                if range.length == 0
                {
                    textField.text = "\(number)-"
                }
            }
            else if length == 6
            {
                let number = textField.text!
                
                if range.length == 0
                {
                    
                    textField.text = "\(number)-"
                    
                }
            }
            
        }
                
        return true
    }
    
    
    func removeCharecterAtLast(number : String) -> String
    {
        let newString = number.replacingOccurrences(of: "-", with: "")
        
        return newString
    }
    
    
    func getLength(mobileNumber : String) -> Int
    {
        let  modifledMobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        return modifledMobileNumber.characters.count
    }
   
    
    
    // MARK: - Local Methods
    func signUPMethod()
    {
        
        if txt_userName.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter user-name")
            
        }else if txt_fullName.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter fullName")
            
        }else if txt_password.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter password")
            
        }
        else if txt_confirmPassWord.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter confirm PassWord")
            
        }else if txt_password.text! != txt_confirmPassWord.text!
        {
            SharedInstance.alertview(message: "Password is not matching")
            
        }
        else if txt_email.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter email")
            
        }
        else if !SharedInstance.isValidEmail(withemail:txt_email.text!)
        {
            SharedInstance.alertview(message: "Please enter the valid email")
        }
        else if txt_zipCode.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter zipCode")
        }
        else if txt_phoneNo.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter phone no")
        }
        else
        {
            self.view.endEditing(true)
            signUPServiceCall()
            
        }
 
    }
    
    func signUPServiceCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let deviceToken = defaults .value(forKey: "deviceToken") as? String

        let RequestParameters =
            [
            "profile_image" : base64ImageString,
            "userName":txt_userName.text!,
            "fullName":txt_fullName.text!,
            "password":txt_password.text!,
            "confirmPassword":txt_confirmPassWord.text!,
            "email":txt_email.text!,
            "phoneNo":txt_phoneNo.text!,
            "pinCode":txt_zipCode.text!,
            "deviceId":"\(SharedInstance.instanceVariable.UUID ?? "0123456789")",
            "deviceType":"\(SharedInstance.instanceVariable.deviceType)",
            "deviceToken": deviceToken ?? "111111"
            ]

        
        WebservicesHandler.signUPServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
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
