//
//  LYAboutUsVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 18/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class LYAboutUsVC: UIViewController,UIGestureRecognizerDelegate,UITextViewDelegate
{
    
    let oldString = NSMutableAttributedString(string: "VENTRE is the combination of the words Venture and Entrepreneur. Our mission is to create resources that help businesses thrive. The solutions we create are easy to use and most are included with membership. Entrepreneurs who understand the needs of business owners founded our organization, which makes us ideal problem solvers. Each program we implement takes into consideration resources such as time, money and effectiveness. Become a member of VENTRE and see the difference we can make for your business.\n\nWant your business listed on this app?   ")
    

    let newString = NSMutableAttributedString(string: "VENTRE is the combination of the words Venture and Entrepreneur. Our mission is to create resources that help businesses thrive. The solutions we create are easy to use and most are included with membership. Entrepreneurs who understand the needs of business owners founded our organization, which makes us ideal problem solvers. Each program we implement takes into consideration resources such as time, money and effectiveness. Become a member of VENTRE and see the difference we can make for your business.\n\nWant your business listed on this app? The purpose of our Cross Industry Loyalty Program is to help you stand out in the crowd and gain NEW customer loyalty. There’s no additional cost to participate, as access is included in your membership.You simply give a 10% discount on goods and/or services to those who present their active proof of membership. What you give out in customer savings will be reciprocated in increased customer volume and/or inventory turn around. Participation can be cancelled at any time by logging in and deselecting this button.Once your membership is activated, your business will appear on our loyalty app. App holders within a 25-mile radius of your location will be notified of your participation.Must be a member of VENTRE to use this service. \n\nFor more information on becoming a member of VENTRE, please visit our website: www.VENTRE.xyz   ")
    
    let linkUrl = "https://www.VENTRE.xyz"

    @IBOutlet weak var textview_AboutText: UITextView!
    var checked : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //changeTextString()
        
        
        // Add tap gesture recognizer to Text View
      //  let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
      //  tap.delegate = self
      //  textview_AboutText.addGestureRecognizer(tap)
        textview_AboutText.delegate = self
        
      
    }

    // MARK: - Local Methods
    func changeTextString()
    {
        // Set an attribute on part of the string
        let myRange = NSRange(location: 511, length: 38)
        let websiteStringRange = NSRange(location: Int(newString.length - 17), length: 14)
        
        let myCustomAttribute = [ "MyCustomAttributeName": "some value"]
        let websiteStringAttribute = [ "websiteStringAttribute": "some value"]
        
        let cutomColor = SharedInstance.hexStringToUIColor(hex: "#0768ef", alphaValue: 1)
        
        if checked{
            
            checked = false
            newString.addAttributes(myCustomAttribute, range: myRange)
            newString.addAttributes(websiteStringAttribute, range: websiteStringRange)
            
            newString.addAttribute(NSForegroundColorAttributeName, value: cutomColor , range: myRange)
            newString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: myRange)
            
            newString.addAttribute(NSForegroundColorAttributeName, value: cutomColor , range: websiteStringRange)
            newString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: websiteStringRange)
            
            textview_AboutText.attributedText = newString
            
        }else{
            
            checked = true
            oldString.addAttributes(myCustomAttribute, range: myRange)
            oldString.addAttribute(NSForegroundColorAttributeName, value: cutomColor , range: myRange)
            oldString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: myRange)
            textview_AboutText.attributedText = oldString
        }
        
        textview_AboutText.font = UIFont(name: "Hero-Light", size: 16)
        textview_AboutText.textAlignment = .justified
    }
    
    
    func myMethodToHandleTap(_ sender: UITapGestureRecognizer)
    {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length
        {
            // print the character index
            //   print("character index: \(characterIndex)")
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            
            _ = (myTextView.attributedText.string as NSString).substring(with: myRange)
            //   print("character at index: \(substring)")
            
            // check if the tap location has a certain attribute
            let attributeName = "MyCustomAttributeName"
            let websiteStringAttribute = "websiteStringAttribute"
            
            let attributeValue = myTextView.attributedText.attribute(attributeName, at: characterIndex, effectiveRange: nil) as? String
            
            let websiteStringattributeValue = myTextView.attributedText.attribute(websiteStringAttribute, at: characterIndex, effectiveRange: nil) as? String
            
            if attributeValue != nil {
                //  print("You tapped on \(attributeName) and the value is: \(value)")
                changeTextString()
            }
            else if websiteStringattributeValue  != nil {
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYVentreWebsiteVC") as! LYVentreWebsiteVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if (URL.absoluteString == linkUrl) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LYVentreWebsiteVC") as! LYVentreWebsiteVC
            self.navigationController?.pushViewController(controller, animated: true)
           // UIApplication.shared.openURL(URL)
        }
        return false
    }
    


    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressBackButton(_ sender: Any)
    {
        self.navigationController!.popViewController(animated: true)
    }

}
