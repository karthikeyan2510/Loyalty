//
//  LYLoginVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 17/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

import MBProgressHUD
import CoreLocation

class LYLoginVC: UIViewController,CLLocationManagerDelegate, UITextFieldDelegate
{
    var isLocationDen: Bool?
    var manager:CLLocationManager = CLLocationManager ()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - IBOutLet
    @IBOutlet weak var view_MainView: UIView!
    @IBOutlet var view_splashScreen: UIView!
    
    
    @IBOutlet weak var txt_userName: UITextField!
    @IBOutlet weak var txt_passWord: UITextField!
    @IBOutlet weak var btn_logIn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // isLocationDen = delegate.isLocationDenied
        
        //        let status = CLLocationManager.authorizationStatus()
        //        if status == .notDetermined {
        //            manager.requestWhenInUseAuthorization()
        //            return
        //        }
        //
        //        if status == .denied || status == .restricted {
        //
        //            let alertController = UIAlertController (title: "Alert", message:  "To work properly, this app requires location services.", preferredStyle: .alert)
        //            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        //            alertController.addAction(cancelAction)
        //
        //            present(alertController, animated: true, completion: nil)
        //            return
        //        }
        
        
        // Ask for Authorisation from the User.
        manager.requestAlwaysAuthorization()
        // For use in foreground
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        else
        {
            SharedInstance.alertview(message: "Please enable location in Settings->Privacy")
        }
        
        
        SharedInstance.setCornerRadiusForTextField(view:view_MainView)
        SharedInstance.setCornerRadiusForUIButton(view:view_MainView)
        
        let defaults = UserDefaults.standard
        let username = defaults .value(forKey: "userName") as? String
        let password = defaults .value(forKey: "passWord") as? String
        
        if ((username?.isEqual(NSNull.self)) != nil)
        {
            txt_userName.text! = "\(username!)"
            txt_passWord.text! = "\(password!)"
            view_splashScreen.frame = self.view.frame
            self.view.addSubview(view_splashScreen)
            loginServiceCall(userName : txt_userName.text!,passWord : txt_passWord.text!)
            MBProgressHUD.hide(for:self.view, animated: true)
        }
    }
    
    func ifDontAllowPressed(){
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined:
                self.manager.delegate = self
                manager.requestWhenInUseAuthorization()
                break
            case .restricted, .denied:
                print("Location Access Not Available")
                
                break
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location Access Available")
                break
            }
        }
    }
    
    func checkUsersLocationServicesAuthorization(){
        // Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined:
                self.manager.delegate = self
                manager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features
                let alert = UIAlertController(title: "Alert", message: "To work properly, this app requires location services.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    print("")
                    UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                }))
                self.present(alert, animated: true, completion: nil)
                print("Location Access Not Available")
                
                
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                print("Location Access Available")
                self.manager.delegate = self
                manager.requestWhenInUseAuthorization()
                break
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        CLLocationManager.authorizationStatus()
        
        //        let alertViewController = UIAlertController.init(title: "", message: "To work properly, this app requires location services.", preferredStyle: .alert)
        //
        //        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //            UIAlertAction in
        //            self.ifDontAllowPressed()
        //        })
        //        self.present(alertViewController, animated: true, completion: nil)
        
        //        let alert = UIAlertController(title: "Your title", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
        //            print("")
        //            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        //        }))
        //        self.present(alert, animated: true, completion: nil)
        
    }
    
    /**  let alert = UIAlertController(title: "Your title", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.alert)
     alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
     print("")
     UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
     }))
     self.present(alert, animated: true, completion: nil)
     */
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.checkUsersLocationServicesAuthorization()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - CLlocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        SharedInstance.appDelegate().myLocation = manager.location!.coordinate
        
    }
    
    
    // MARK: - ButtonAction
    @IBAction func pressForgotPassWordButton(_ sender: Any)
    {
        self.view.endEditing(true)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYForgotPasswordVC") as! LYForgotPasswordVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func pressLoginButton(_ sender: Any)
    {
        
        if txt_userName.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter user-name or Email")
        }else if txt_passWord.text!.isEmpty
        {
            SharedInstance.alertview(message: "Please enter password")
        }else
        {
            self.view.endEditing(true)
            loginServiceCall(userName : txt_userName.text!,passWord : txt_passWord.text!)
        }
        
    }
    @IBAction func pressRegisterButton(_ sender: Any)
    {
        self.view.endEditing(true)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYSignUpVC") as! LYSignUpVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Local Methods
    func loginServiceCall(userName : String,passWord : String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let RequestParameters = ["userName" : userName,
                                 "password" : passWord,
                                 ]
        
        WebservicesHandler.logInServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataDictionary = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    
                    if result?.lowercased() == "success"
                    {
                        
                        let model = loginModel()
                        model.email = "\(dataDictionary?["email"] ?? "")"
                        model.fullname = "\(dataDictionary?["fullname"] ?? "")"
                        model.phoneNo = "\(dataDictionary?["phoneNo"] ?? "")"
                        model.pincode = "\(dataDictionary?["pincode"] ?? "")"
                        model.uid = "\(dataDictionary?["uid"] ?? "")"
                        model.userName = "\(dataDictionary?["userName"] ?? "")"
                        model.oldPassword = "\(self.txt_passWord.text!)"
                        model.userImage = "\(dataDictionary?["userImage"] ?? "")"
                        model.isChanged = false
                        model.payment_status = "\(dataDictionary?["payment_status"] ?? "")"
                        model.loyalty_participate_amnt = "\(dataDictionary?["loyalty_participate_amnt"] ?? "")"
                        
                        SharedInstance.saveUserLoginDetails(mode: model)
                        
                        
                        UserDefaults.standard.setValue(self.txt_userName.text!, forKey: "userName")
                        UserDefaults.standard.setValue(self.txt_passWord.text!, forKey: "passWord")
                        UserDefaults.standard.synchronize()
                        
                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    }else
                    {
                        self.view_splashScreen.removeFromSuperview()
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
