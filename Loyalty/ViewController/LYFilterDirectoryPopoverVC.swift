//
//  LYFilterDirectoryPopoverVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 18/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation


class LYFilterDirectoryPopoverVC: UIViewController,CLLocationManagerDelegate
{

    
    var popOver : popOverDlegeteClass?
    var searchListingArray : Array<listingDataModel> =  []
    

    @IBOutlet weak var txt_CityName: UITextField!
    @IBOutlet weak var txt_ZipCode: UITextField!
    @IBOutlet weak var txt_Distance: UITextField!
    @IBOutlet weak var view_Bckground: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        /*
         
        if SharedInstance.IPHONE_5
        {
            self.view_Bckground.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            self.view_Bckground.addGestureRecognizer(tap)
        } 
         */
        
        
        
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressSearchButton(_ sender: Any)
    {
        if !txt_CityName.text!.isEmpty || !txt_ZipCode.text!.isEmpty || !txt_Distance.text!.isEmpty
        {
            listDataServiceCall()
        }else
        {
            SharedInstance.alertview(message: "Please enter City / ZipCode" )
        }
        
    }
    @IBAction func pressCloseButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    // MARK: - Local Methods
    
    func handleTap(_ sender: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func listDataServiceCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let RequestParameters =
            [
                "keyword" : txt_CityName.text!,
                "zipcode" : txt_ZipCode.text!,
                "distance": txt_Distance.text!,
                "lat" : "\(SharedInstance.appDelegate().myLocation.latitude)",
                "lon": "\(SharedInstance.appDelegate().myLocation.longitude)",
            ]

        WebservicesHandler.searchListingServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataArray = serviceResponse["data"] as? NSArray
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    if result?.lowercased() == "success"
                    {
                        SharedInstance.appDelegate().dataListArray.removeAll()
                        for case let dataDictionary as NSDictionary in dataArray!
                        {
                            
                            let title = dataDictionary["title"] as? String
                            let city = dataDictionary["city"] as? String
                            _ = dataDictionary["country"] as? String
                            let state = dataDictionary["state"] as? String
                            let image_name = dataDictionary["image_name"] as? String
                            let listid = dataDictionary["listing_id"] as? String
                            let user_id = dataDictionary["user_id"] as? String
                            let  check_loyalty = dataDictionary["check_loyalty"] as? String
                             let  review = dataDictionary["review"] as? String
                            
                            let model = listingDataModel()
                            model.title = "\(title ?? "")"
                            model.cityCountry = "\(city ?? ""), \(state ?? "")"
                            model.imageURL = "\(image_name ?? "")"
                            model.listid = "\(listid ?? "")"
                            model.user_id = "\(user_id ?? "")"
                            model.fCheckLoyalty = "\(check_loyalty ?? "")"
                             model.review = "\(review ?? "")"
                            
                            self.searchListingArray.append(model)
                            
//                            if model.fCheckLoyalty == "1" {
//
//                                //model.fCheckLoyalty = "\(image_name ?? "")"
//
//                                //cell?.TenPercentageImage.image = UIImage(named:"10percentage")
//                              //  cell?.TenPercentageImage.isHidden = false
//                            }
//                            else {
//
//                                cell?.TenPercentageImage.isHidden = true
//                            }
                            
                            
                        }
                        
                        SharedInstance.appDelegate().dataListArray = self.searchListingArray
                        
                        self.dismiss(animated: true, completion: nil)
                        self.popOver?.searchSelectedObject(Message: "i am passed")
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
