//
//  LYEditeProfileVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 18/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD


class LYEditeProfileVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate

{
    let defaults = UserDefaults.standard
    let loginModel = SharedInstance.returnUserLoginDetails()

    var isEdit : Bool = true
    
    
    @IBOutlet weak var txt_userName: UITextField!
    @IBOutlet weak var txt_FullName: UITextField!
    @IBOutlet weak var txt_EmailAddress: UITextField!
    @IBOutlet weak var txt_PhoneNo: UITextField!
    @IBOutlet weak var txt_ZipCode: UITextField!
    @IBOutlet weak var txt_ChagePassword: UITextField!
    @IBOutlet weak var img_ProfileImage: UIImageView!
    @IBOutlet weak var btn_profileImage: UIButton!
    
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_Update: UIButton!
  
    var imagePicker = UIImagePickerController()
    var base64ImageString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let imageArr = ["userIcon","fullName","emailAddress","phoneIcon","zipCode","changePassword"]
        let array = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode,txt_ChagePassword]
        
        SharedInstance.paddingViewWithImage(textFieldArray : array as NSArray,imageArr: imageArr as NSArray)
        
        img_ProfileImage.layoutIfNeeded()
        img_ProfileImage.layer.cornerRadius = img_ProfileImage.frame.size.height/2
        img_ProfileImage.layer.masksToBounds = true
        
        let textFieldArr = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode] as NSArray
        disableTextField(textFieldArray :textFieldArr)
       
        self.btn_profileImage.isUserInteractionEnabled = false
        self.btn_Update.isUserInteractionEnabled = false
        self.btn_Update.alpha = 0.5
        
        img_ProfileImage.sd_setImage(with: URL(string:loginModel.userImage), placeholderImage: UIImage(named: "loading-1.gif"))
        showUserDetails(Model:loginModel)
        
        txt_PhoneNo.delegate = self
        txt_ZipCode.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressBackButton(_ sender: Any)
    {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func pressUpdatePasswordButton(_ sender: Any)
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYUpdatePasswordVC") as! LYUpdatePasswordVC
        self.view.endEditing(true)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func pressChooseProfileImageButton(_ sender: Any)
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
    
    @IBAction func pressEditButton(_ sender: Any)
    {
         editProfile()
    }
    
    @IBAction func pressupdateButton(_ sender: Any)
    {
     
            self.editProfileServiceCall()
    
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
        if textField == txt_ZipCode
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
        else if textField == txt_PhoneNo
        {
            let length = getLength(mobileNumber: textField.text!)
            
            if length == 10
            {
                
                if range.length == 0
                {
                    return false
                }
            }
            
            if length == 3
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // MARK: - Local Methods
    
    func editProfile()
    {
        
        let textFieldArr = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode] as NSArray
        enableTextField(textFieldArray :textFieldArr)
        self.btn_profileImage.isUserInteractionEnabled = true
        self.btn_Update.isUserInteractionEnabled = true
        self.btn_Update.alpha = 1
        
    
        /*
    
        if isEdit
        {
            btn_Edit.setTitle("Save", for: UIControlState.normal)
            self.isEdit = false
            
            let textFieldArr = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode] as NSArray
            enableTextField(textFieldArray :textFieldArr)
            txt_userName.becomeFirstResponder()
            
        }else
        {
            self.view.endEditing(true)
            self.isEdit = true
            self.btn_Edit.setTitle("Edit", for: UIControlState.normal)
            let textFieldArr = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode] as NSArray
            disableTextField(textFieldArray :textFieldArr)
        }
        
        if txt_userName.text! != loginModel.userName || txt_FullName.text! != loginModel.fullname
            || txt_EmailAddress.text! != loginModel.email || txt_PhoneNo.text! != loginModel.phoneNo || txt_ZipCode.text! != loginModel.pincode || !base64ImageString.isEmpty
        {
            if !SharedInstance.isValidEmail(withemail:txt_EmailAddress.text!)
            {
                SharedInstance.alertview(message: "Please enter the valid email")
                
                btn_Edit.setTitle("Save", for: UIControlState.normal)
                self.isEdit = false
                let textFieldArr = [txt_userName,txt_FullName,txt_EmailAddress,txt_PhoneNo,txt_ZipCode] as NSArray
                enableTextField(textFieldArray :textFieldArr)
                txt_EmailAddress.becomeFirstResponder()
                
            }else
            {
                self.btn_Update.isUserInteractionEnabled = true
                self.btn_Update.alpha = 1
            }
        }else
        {
            self.btn_Update.isUserInteractionEnabled = false
            self.btn_Update.alpha = 0.5
        }
    
    */
    
    }
    
    
    func showUserDetails(Model:loginModel)
     {
        txt_userName.text = Model.userName
        txt_FullName.text = Model.fullname
        txt_EmailAddress.text = Model.email
        txt_PhoneNo.text = Model.phoneNo
        txt_ZipCode.text = Model.pincode
     }
    
    
     func disableTextField(textFieldArray : NSArray)
     {
       self.btn_profileImage.isUserInteractionEnabled = false
        for case let textField as UITextField in textFieldArray
        {
            textField.isUserInteractionEnabled = false
        }
     }
    
    func enableTextField(textFieldArray : NSArray)
    {
        self.btn_profileImage.isUserInteractionEnabled = true
        for case let textField as UITextField in textFieldArray
        {
            textField.isUserInteractionEnabled = true
        }
    }
    
    func editProfileServiceCall()
    {
        if base64ImageString.isEmpty
        {
           let finalImage = SharedInstance.resizeImage(image : self.img_ProfileImage.image!)
           base64ImageString = SharedInstance.convertImageToBase64(image:finalImage)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let deviceToken = defaults .value(forKey: "deviceToken") as? String
        let RequestParameters =
            [
                "profile_image" : base64ImageString,
                "uid":loginModel.uid,
                "userName" : txt_userName.text!,
                "fullName" : txt_FullName.text!,
                "email" : txt_EmailAddress.text!,
                "phoneNo" : txt_PhoneNo.text!,
                "pinCode" : txt_ZipCode.text!,
                "deviceId" : "\(SharedInstance.instanceVariable.UUID ?? "0123456789")",
                "deviceType" : "\(SharedInstance.instanceVariable.deviceType)",
                "deviceToken" : deviceToken ?? "111111"
             ]
        
        WebservicesHandler.editProfileServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataDictionary = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    
                    if result?.lowercased() == "success"
                    {
                        SharedInstance.alertview(message: messageString ?? "")
                        
                        self.loginModel.email = "\(dataDictionary?["email"] ?? "")"
                        self.loginModel.fullname = "\(dataDictionary?["fullname"] ?? "")"
                        self.loginModel.phoneNo = "\(dataDictionary?["phoneNo"] ?? "")"
                        self.loginModel.pincode = "\(dataDictionary?["pinCode"] ?? "")"
                        self.loginModel.userName = "\(dataDictionary?["username"] ?? "")"
                        self.loginModel.userImage = "\(dataDictionary?["user_image"] ?? "")"
                        self.loginModel.storedImage = self.img_ProfileImage.image!
                        self.loginModel.isChanged = true
                        
                        SharedInstance.saveUserLoginDetails(mode:self.loginModel)
                        self.showUserDetails(Model:SharedInstance.returnUserLoginDetails())
                        
                        let textFieldArr = [self.txt_userName,self.txt_FullName,self.txt_EmailAddress,self.txt_PhoneNo,self.txt_ZipCode] as NSArray
                        self.disableTextField(textFieldArray : textFieldArr)
                        self.btn_Update.isUserInteractionEnabled = false
                        self.btn_Update.alpha = 0.5
                        
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
