//
//  LYMembershipVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 18/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD



class LYMembershipVC: UIViewController
{

    @IBOutlet weak var btn_memberShipid: UIButton!
    @IBOutlet weak var img_BarCodeImageView: UIImageView!
    @IBOutlet weak var btn_userName: UIButton!
    @IBOutlet weak var btn_renewMembership: UIButton!
    
    let loginModel = SharedInstance.returnUserLoginDetails()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      
        btn_renewMembership.isHidden = true
        
        GenerateUPCServiceCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func GenerateUPCServiceCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let loginModel = SharedInstance.returnUserLoginDetails()
        
        let RequestParameters =
            [
                "uid":loginModel.uid,
            ]
        
        WebservicesHandler.GenerateUPCServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataDictionary = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    
                    if result?.lowercased() == "success"
                    {
                        
                        _ = "\(dataDictionary?["upccode"] ?? "")"
                        _ = "\(dataDictionary?["expire_date"] ?? "")"
                        let imageURL = "\(dataDictionary?["upcimage"] ?? "")"
                        let memberShipId = "\(dataDictionary?["membercode"] ?? "")"
                        let username = "\(dataDictionary?["fullname"] ?? "")"
                        let status = "\(dataDictionary?["status"] ?? "")"
                        
                        self.btn_memberShipid.setTitle("Membership ID : \(memberShipId)", for: UIControlState.normal)
                        self.btn_userName.setTitle("Name : \(username)", for: UIControlState.normal)
                        self.img_BarCodeImageView.sd_setImage(with: URL(string:imageURL), placeholderImage: UIImage(named: ""))
                       
                        if status.lowercased() == "1"
                        {
                            self.btn_renewMembership.isHidden = false
                        }
                        
                        /*
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-dd"
                        
                        let currentDate = dateFormatter.string(from: date)
                       
                        if expire_date.lowercased() == currentDate
                        {
                            self.btn_renewMembership.isHidden = false
                        }
                        */
                        
                        
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

    // MARK: - ButtonAction
    @IBAction func pressRenewMembershipButton(_ sender: Any)
    {
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYTermsofServicesVC") as! LYTermsofServicesVC
//        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func pressDoneButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }

    @IBAction func pressBackButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }
}
