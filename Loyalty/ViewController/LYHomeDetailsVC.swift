//
//  LYHomeDetailsVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 20/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//new code

import UIKit
import MBProgressHUD
import AVKit
import AVFoundation


@available(iOS 10.0, *)
class LYHomeDetailsVC: UIViewController,UITextViewDelegate{
    
    var listingModel = listingDataModel()
    var urlLink = ""
    var reviewLink = ""
    var phoneNumber = String()
    var latitude = String()
    var longitude = String()
    
    var FAdreess:String?
    var FWebsite:String?
    
    @IBOutlet weak var heightContraintContentView: NSLayoutConstraint!
    @IBOutlet weak var txtview_textviewDetails: UITextView!
    @IBOutlet weak var view_viewInformation: UIView!
    @IBOutlet weak var lbl_tittleName: UILabel!
    @IBOutlet weak var lbl_addressLine1: UILabel!
    @IBOutlet weak var lbl_addressLine2: UILabel!
    @IBOutlet weak var lbl_countryCity: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_webSiteLink: UILabel!
    @IBOutlet weak var lbl_HotelName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    var address :String?
    var Website : String?
    var PhoneNo: String?
    var FheadTitle:String?
    var address2:String?
    var addressCountry:String?
    var review:String?
    
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    var avPlayerLayer: AVPlayerLayer!
    
    var paused: Bool = false

    
    @IBOutlet var videoViw: UIView!
  //  let avPlayerViewController = CustomAVPlayerC()
   // var playerView: AVPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // playvideo()
        
        shareBtn.layer.cornerRadius = shareBtn.frame.size.height/2
        shareBtn.clipsToBounds = true
        txtview_textviewDetails.delegate = self
        detailsListingServiceCall()
    }
    
    override func viewWillLayoutSubviews() {
        //playvideo()
        
    }
    
    override func viewDidLayoutSubviews() {
       // playvideo()
    }
    
    

    func playvideo(){
        guard let path = Bundle.main.path(forResource: "Ventre", ofType:"mp4") else {
            debugPrint("Ventre.mp4 not found")
            return
        }
        
        self.avPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        avPlayerLayer.frame = videoViw.frame

        videoViw.backgroundColor = UIColor.clear;
      //  videoViw.layer.addSublayer(avPlayerLayer)
         videoViw.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { [weak self] _ in
            self?.avPlayer?.seek(to: kCMTimeZero)
            self?.avPlayer?.play()
        }
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       playvideo()
        avPlayer.play()
        paused = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pressBackButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func pressWebLinkButton(_ sender: Any)
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYHomeDetailsWebViewVC") as! LYHomeDetailsWebViewVC
        controller.URLAddress = urlLink
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func pressreviewLinkButton(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYHomeDetailsWebViewVC") as! LYHomeDetailsWebViewVC
        controller.URLAddress = reviewLink
        print(reviewLink)
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @IBAction func pressCallButton(_ sender: Any)
    {
        if !self.lbl_phone.text!.isEmpty
        {
             callNumber(phoneNumber:phoneNumber)
        }
    }
    
    @IBAction func pressRoutAddressButton(_ sender: Any)
    {
        
        if !self.latitude.isEmpty && !self.longitude.isEmpty
        {
            /*
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL))
            {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(self.latitude),\(self.longitude)&directionsmode=driving")! as URL)
            } else
            {
                NSLog("Can't use comgooglemaps://");
                
                UIApplication.shared.openURL(NSURL(string:
                    "https://itunes.apple.com/us/app/google-maps-navigation-transit/id585027354?mt=8")! as URL)
            } */
            
            if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL))
            {
               UIApplication.shared.openURL(NSURL(string: "http://maps.apple.com/?daddr=\(self.latitude),\(self.longitude)&saddr=")! as URL)
                //UIApplication.shared.openURL(NSURL(string: "http://maps.apple.com/?daddr=\("37.0902"),\("95.7129")&saddr=")! as URL)
            } else
            {
                SharedInstance.alertview(message: "Can't use Apple Maps")
            }
            
        }
    }
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func ShareBtnAction(_ sender: UIButton) {
        FAdreess = "Address" + address!
         FWebsite = "Website" + Website!

        let attributedString = NSMutableAttributedString(string: "Want to learn iOS? You should visit the best source of free iOS tutorials!")
        attributedString.addAttribute(FWebsite!, value: FWebsite, range: NSRange(location: 19, length: 55))


        var FPhone :String? = "Phone Number" + PhoneNo!
        var FHeadName:String? = "Business Name : " + FheadTitle!
        let myWebsite =  NSURL(string:"https://itunes.apple.com/us/app/saveme10/id1276157976?ls=1&mt=8")
        let myWebsite1 = "https://itunes.apple.com/us/app/saveme10/id1276157976?ls=1&mt=8"
        var FLink :String?
        FLink = "AppLink : " + myWebsite1
        var Freview:String? = "Reviews " + review!
        


        let text =  "\("VENTRE Member") \n \(FHeadName!) \n \(FAdreess!) \n \(address2!) \(addressCountry!) \n \(FWebsite!) \n \(FPhone!) \n \(FLink!) \n \(Freview!)"

        print(text)
        let img: UIImage = UIImage(named: "logoIcon")!
        
       //let Final = text + "" + myWebsite
        // set up activity view controller
        let textToShare = [text,img] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
 
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        
        
        return (string == filtered)
    }
    func removeSpecialCharsFromString(_ str: String) -> String {
        struct Constants {
            static let validChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_ "
        }
        return String(str.characters.filter { Constants.validChars.contains($0) })
    }
    
    // MARK: - Local Methods
    func detailsListingServiceCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
           let RequestParameters =
            [
                "listing_id":listingModel.listid,
            ]
        
        WebservicesHandler.detailsListingServiceCall(serviceRequestParameters : RequestParameters as NSDictionary,onCompletion: {(serviceResponse)in
            DispatchQueue.main.async
                {
                    MBProgressHUD.hide(for:self.view, animated: true)
                    let dataDictionary = serviceResponse["data"] as? NSDictionary
                    let messageString = serviceResponse["message"] as? NSString
                    let result = serviceResponse["result"] as? String
                    
                    print(dataDictionary)
                    
                    if result?.lowercased() == "success"
                    {
                        do
                        {
                            let testString : String = "\(dataDictionary?["description"] ?? "")"
                            let newTestString:String = self.removeCharecterAtLast1(number: testString)
                           // let serviceResponse = try testString.convertHtmlSymbols()
                            self.txtview_textviewDetails.text = newTestString
                        }
                        catch
                        {
                            // print("Exception in details page")
                        }
                        let titleName = dataDictionary?["title"] as? NSString ?? ""
                        
                        let decodedString = String(htmlEncodedString: titleName as String)
                        // self.txtview_textviewDetails.text = "\(dataDictionary?["description"] ?? "")"
                        self.lbl_tittleName.text = " : \(decodedString ?? "")"
                        self.lbl_addressLine1.text = " : \(dataDictionary?["address1"] ?? "")"
                        self.address = " : \(dataDictionary?["address1"] ?? "")"
                        self.lbl_addressLine2.text = "   \(dataDictionary?["address2"] ?? "")"
                        self.address2 = "   \(dataDictionary?["address2"] ?? "")"
                        
                        self.Website = " : \(dataDictionary?["www"] ?? "")"
                        print(" : \(dataDictionary?["www"] ?? "")")
                        print(" : \(dataDictionary?["review"] ?? "")")
                        self.lblReview.text  = " : \(dataDictionary?["review"] ?? "")"
                        
                        print(self.lblReview.frame.height)
                          print(self.heightContraintContentView.constant)
                        
                        self.heightContraintContentView.constant = self.lblReview.frame.height + self.heightContraintContentView.constant
                        print(self.heightContraintContentView.constant)
                        self.lbl_countryCity.text = "   \(dataDictionary?["city"] ?? ""),\(dataDictionary?["state"] ?? ""), \(dataDictionary?["zipcode"] ?? "")"
                        
                        // self.addressCountry = "   \(dataDictionary?["city"] ?? ""),\(dataDictionary?["state"] ?? "")"
                        
                        self.addressCountry = "   \(dataDictionary?["city"] ?? ""),\(dataDictionary?["state"] ?? ""), \(dataDictionary?["zipcode"] ?? "")"
                        
                        self.lbl_webSiteLink.text = " : \(dataDictionary?["www"] ?? "")"
                        self.lbl_phone.text = " : \(dataDictionary?["phone"] ?? "")"
                        self.PhoneNo = " : \(dataDictionary?["phone"] ?? "")"
                        self.review = " : \(self.listingModel.review )"
                        self.lblReview.text  = " : \(self.listingModel.review )"
                        
                        self.urlLink = "\(dataDictionary?["www"] ?? "")"
                        self.reviewLink = self.listingModel.review
                        
                        self.lbl_HotelName.text = "\(decodedString ?? "")"
                        self.FheadTitle = "\(decodedString ?? "")"
                        self.txtview_textviewDetails.font = UIFont(name: "Hero-Light", size: 16)
                        self.txtview_textviewDetails.textAlignment = .justified
                        
                        
                        self.phoneNumber = "\(dataDictionary?["phone"] ?? "")"
                        self.latitude = "\(dataDictionary?["latitude"] ?? "")"
                        self.longitude = "\(dataDictionary?["longitude"] ?? "")"
                        
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
    
    func callNumber(phoneNumber:String) {
        
        let number : String = removeCharecterAtLast(number : phoneNumber)
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: number))
        
        if number.isEmpty || !isNumber {
            SharedInstance.alertview(message: "This is not valid phone number.")
            return
        }
        let url:NSURL = NSURL(string: "telprompt://\(number)")!
        UIApplication.shared.openURL(url as URL)
    }
    
    func removeCharecterAtLast(number : String) -> String {
        
        var newString = number.replacingOccurrences(of: "-", with: "")
        newString = newString.replacingOccurrences(of: "@", with: "")
        newString = newString.replacingOccurrences(of: "#", with: "")
        newString = newString.replacingOccurrences(of: "$", with: "")
        newString = newString.replacingOccurrences(of: "(", with: "")
        newString = newString.replacingOccurrences(of: ")", with: "")
        newString = newString.replacingOccurrences(of: " ", with: "")
        return newString
    }
    
    func removeCharecterAtLast1(number : String) -> String {
        
        //var newString = number.replacingOccurrences(of: "-", with: "")
         var newString = number.replacingOccurrences(of: "@", with: "")
        newString = newString.replacingOccurrences(of: "#", with: "")
       // newString = newString.replacingOccurrences(of: "$", with: "")
        newString = newString.replacingOccurrences(of: "(", with: "")
        newString = newString.replacingOccurrences(of: ")", with: "")
        newString = newString.replacingOccurrences(of: "&146;", with: "'")
        newString = newString.replacingOccurrences(of: "&151;", with: "——")
        return newString
    }
    
}

extension String
{
    func convertHtmlSymbols() throws -> String?
    {
        guard let data = data(using: .utf8) else { return nil }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}
