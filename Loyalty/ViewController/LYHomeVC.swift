//
//  LYHomeVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 13/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage



protocol popOverDlegeteClass
{
    func searchSelectedObject(Message : String)
}

class LYHomeVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,popOverDlegeteClass,UISearchBarDelegate
{
  
    let loginModel = SharedInstance.returnUserLoginDetails()
    @IBOutlet weak var tbl_specialTableView: UITableView!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var FCheckLoyalty : String?
    
    
    var teststring = ""
    var dataListFillteredArray : Array<listingDataModel> =  []
    
    var isfilltered : Bool = false
    let defaults = UserDefaults.standard
    
     var DupArr : Array<listingDataModel> =  []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigateToViewController(value:teststring)
        let combinedEAcute: Character.UnicodeScalarLiteralType = "\u{0013}"
        print(combinedEAcute)
        tbl_specialTableView.reloadData()
 

       

    }
    override func viewWillAppear(_ animated: Bool) {
        // tbl_specialTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    // MARK: - Local Methods
    func navigateToViewController(value:String)
    {
        if value == "1" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYAboutUsVC") as! LYAboutUsVC
            self.navigationController?.pushViewController(controller, animated: true)
        } else if value == "2" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYEditeProfileVC") as! LYEditeProfileVC
            self.navigationController?.pushViewController(controller, animated: true)
        }else if value == "3"
        {
            if loginModel.payment_status.lowercased() == "1"
            {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYMembershipVC") as! LYMembershipVC
                self.navigationController?.pushViewController(controller, animated: true)
            }else
            {
                SharedInstance.alertview(message: "You are not a member of the VENTRE Loyalty Program")
            }
        } else {
            listDataServiceCall()
        }
    }
    
    func searchSelectedObject(Message: String)
    {
        isfilltered = false
        dataListFillteredArray.removeAll()
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.tbl_specialTableView.reloadData()
        self.tbl_specialTableView.setContentOffset(CGPoint.zero, animated: false)
        
    }
    
    
    // MARK: - Button Action
    @IBAction func pressMenuButton(_ sender: Any)
    {
        let elDrawer: KYDrawerController? = (navigationController?.parent as? KYDrawerController)
        elDrawer?.setDrawerState(.opened, animated: true)
    }

    @IBAction func pressFilterButton(_ sender: Any)
    {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false

        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LYFilterDirectoryPopoverVC") as! LYFilterDirectoryPopoverVC
        popController.modalPresentationStyle = .overFullScreen
        popController.popOver = self
        self.present(popController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (isfilltered)
        {
            return self.dataListFillteredArray.count
        }
        return SharedInstance.appDelegate().dataListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? LYHomeVCTableViewCell
       
        var model = listingDataModel()
        if (isfilltered) {
           model = self.dataListFillteredArray[indexPath.row]
        } else {
            model = SharedInstance.appDelegate().dataListArray[indexPath.row]
        }
        
        cell?.view_BackgroundView.layer.cornerRadius = 5
        cell?.img_imageView.layoutIfNeeded()
        cell?.img_imageView.layer.cornerRadius = (cell?.img_imageView.frame.size.width)!/2
        cell?.img_imageView.layer.masksToBounds = true
        
       
        let decodedString = String(htmlEncodedString: model.title)
        cell?.lbl_titleName.text = decodedString
        cell?.lbl_subTitleName.text = model.cityCountry
        
    
        if model.fCheckLoyalty == "1" {
            print(
            )
            cell?.TenPercentageImage.image = UIImage(named:"10percentage")
            cell?.TenPercentageImage.isHidden = false
        }
        else {
             cell?.TenPercentageImage.isHidden = true
        }
        
    
        
        let url: URL? = Bundle.main.url(forResource: "loading-1", withExtension: "gif")
        cell?.img_imageView.sd_setImage(with: URL(string: model.imageURL), placeholderImage: UIImage.animatedImage(withAnimatedGIFURL: url!))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: "LYHomeDetailsVC") as! LYHomeDetailsVC
        
        if (isfilltered) {
            controller.listingModel = self.dataListFillteredArray[indexPath.row]
        } else {
            controller.listingModel = SharedInstance.appDelegate().dataListArray[indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if SharedInstance.instanceVariable.deviceType.lowercased() != "ipad"
        {
            let cellDefaultHeight: CGFloat = 70
            let screenDefaultHeight: CGFloat = 568
            let factor: CGFloat = cellDefaultHeight / screenDefaultHeight
            return factor * UIScreen.main.bounds.size.height
        }else
        {
            return 70
        }
    }
    
    // MARK: - SearchBar Delegate Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = true
        self.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isfilltered = false
        self.tbl_specialTableView.reloadData()
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if dataListFillteredArray.count == 0
        {
             self.searchBar.resignFirstResponder()
             self.searchBar.showsCancelButton = false
        }else
        {
             self.searchBar.text = ""
             self.searchBar.resignFirstResponder()
             self.searchBar.showsCancelButton = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if (searchText.characters.count == 0)
        {
            isfilltered = false
        }
        else
        {
            isfilltered = true
            dataListFillteredArray.removeAll()
            DupArr.removeAll()
            for  model in SharedInstance.appDelegate().dataListArray
            {
                var str_range = NSRange()
                var str_range2 = NSRange()
                let searchStr = "\(model.title)" as NSString
                let searchstr2 = "\(model.keywords)" as NSString
                str_range = searchStr.range(of: "\(searchText)", options: .caseInsensitive)
                
                if str_range.location != NSNotFound
                {
                    dataListFillteredArray.append(model)
                }
                str_range2 = searchstr2.range(of: "\(searchText)", options: .caseInsensitive)
                
                if str_range2.location != NSNotFound
                {
                    dataListFillteredArray.append(model)
                }
            }
//            print("Original Array :",dataListFillteredArray)
            for value in dataListFillteredArray
            {
                if !DupArr.contains(value)
                {
                    DupArr.append(value)
                }
            }
            dataListFillteredArray.removeAll()
          dataListFillteredArray = DupArr
        // print("Remove Dup :",DupArr[0].keywords)
        }
         self.tbl_specialTableView.reloadData()
    }
    
    
    
    
    // MARK: - Local Methods
    
    func listDataServiceCall()
    {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SharedInstance.appDelegate().dataListArray.removeAll()
        
        let deviceToken = defaults .value(forKey: "deviceToken") as? String
        let  RequestParameters =
            [
                "distance":"25",
                "lat" : "\(SharedInstance.appDelegate().myLocation.latitude)",
                "lon": "\(SharedInstance.appDelegate().myLocation.longitude)",
                "uid":loginModel.uid,
                "deviceId" : "\(SharedInstance.instanceVariable.UUID ?? "0123456789")",
                "deviceType" : "\(SharedInstance.instanceVariable.deviceType)",
                "deviceToken" : deviceToken ?? "111111"
            ]
        
        print(RequestParameters)
        
        WebservicesHandler.listDataServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    print(serviceResponse)
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataArray = serviceResponse["data"] as? NSArray
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
//                    var CheckLoyalty:String = dataArray!["check_loyalty"] as? Int
//                    print(CheckLoyalty)
                    
                    
                    
                    print(dataArray)
                    if result?.lowercased() == "success"
                    {
                        for case let dataDictionary as NSDictionary in dataArray!
                        {
                            let title = dataDictionary["title"] as? String
                            let keyword = dataDictionary["keywords"] as? String
        
                            print(keyword)
                            let city = dataDictionary["city"] as? String
                            _ = dataDictionary["country"] as? String
                            let state = dataDictionary["state"] as? String
                            let review = dataDictionary["review"] as? String
                            print(review)
                            let image_name = dataDictionary["image_name"] as? String
                            let listid = dataDictionary["listid"] as? String
                            let user_id = dataDictionary["user_id"] as? String
                            let fCheckLoyalty = dataDictionary["check_loyalty"] as? String
                            print(fCheckLoyalty)
                           
                         
                            let model = listingDataModel()
                            model.title = "\(title ?? "")"
                            
                            model.cityCountry = "\(city ?? ""), \(state ?? "")"
                            model.imageURL = "\(image_name ?? "")"
                            model.listid = "\(listid ?? "")"
                            model.user_id = "\(user_id ?? "")"
                            model.fCheckLoyalty = "\(fCheckLoyalty ?? "")"
                            model.keywords = "\(keyword ?? "")"
                              model.review = "\(review ?? "")"
                            
                            SharedInstance.appDelegate().dataListArray.append(model)
                        }
                        self.tbl_specialTableView.reloadData()
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






extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}
