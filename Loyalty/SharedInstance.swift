//
//  SharedInstance.swift
//  JobOrder
//
//  Created by CIPL204-MOBILITY on 7/27/16.
//  Copyright © 2016 Abdul Jabbar.S @ AJ. All rights reserved.
//

import UIKit
import MBProgressHUD

var userloginDetails = loginModel()

class SharedInstance: NSObject {
    // MARK: - Singleton Declaration
    static var instanceVariable = SharedInstance()
    
    var UUID = UIDevice.current.identifierForVendor?.uuidString
    var deviceType = UIDevice.current.model
    
    class func setPerticularViewControllerOrientation() {
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    // MARK: - save User Login Details
    class func saveUserLoginDetails(mode : loginModel) {
        userloginDetails = mode
    }
    
    // MARK: - return User Login Details
    class func returnUserLoginDetails() -> loginModel {
        return userloginDetails
    }
    
    //Set PlaceHolder Text Asterix in RED Color
    class func setPlcaeHolderTextAsterixSymboleTextColor(textFieldArr: Array<UITextField>) {
        
        for case let textField in textFieldArr {
            var placeHolder = NSMutableAttributedString()
            let placeHolderText  = textField.placeholder!
            let index = placeHolderText.characters.index(of: "*")
            if index != nil {
                let intIndex = placeHolderText.distance(from: placeHolderText.startIndex, to: index!)
                // Set the Font
                placeHolder = NSMutableAttributedString(string:placeHolderText, attributes: [NSFontAttributeName:UIFont(name:(textField.font?.fontName)!, size: (textField.font?.pointSize)!)!])
                // Set the color
                placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:intIndex,length:1))
                placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range:NSRange(location:0,length: intIndex))
                // Add attribute
                textField.attributedPlaceholder = placeHolder
            }
        }
    }

    class func hideCustomMBProgressHUD(view: UIView) {
        
        MBProgressHUD.hide(for:view, animated: true)
    }
    
    // MARK: - AlertView
    class func alertview(message : NSString) {
        let alert = UIAlertView()
        alert.title = "Alert!"
        alert.message = message as String
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    // MARK: - paddingView
    class func paddingView(textFieldArray : NSArray) {
        for case let textField as UITextField in textFieldArray
        {
            let frame = CGRect(x: 0, y: 0, width: 15, height: textField.frame.size.height)
            let paddingView = UIView(frame: frame)
            textField.leftView = paddingView
            textField.leftViewMode = UITextFieldViewMode.always
        }
    }
    
    class func paddingViewWithImage(textFieldArray : NSArray,imageArr : NSArray)
    {
        var i = 0
        for case let textField as UITextField in textFieldArray
        {
            textField.layoutIfNeeded()
            
            var frame = CGRect()
            
            if SharedInstance.instanceVariable.deviceType.lowercased() == "ipad"
            {
                frame = CGRect(x: -20, y: 0, width: 20, height: 20)
            }
            else if !SharedInstance.IPHONE_5
            {
                frame = CGRect(x: -20, y: 0, width: textField.frame.size.height-35, height: textField.frame.size.height-35)
            }
            else
            {
                frame = CGRect(x: -20, y: 0, width: textField.frame.size.height-25, height: textField.frame.size.height-25)
            }
            
            let paddingView = UIView(frame: frame)
            let imageview = UIImageView(frame:frame)
            imageview.image = UIImage(named:imageArr[i] as! String)
            imageview.contentMode = .scaleAspectFit
            paddingView.addSubview(imageview)
            textField.layer.sublayerTransform = CATransform3DMakeTranslation(40, 0.0, 0.0)
            textField.leftView = paddingView
            textField.leftViewMode = UITextFieldViewMode.always
            i = i+1
        }
    }
    
    // MARK: - Check valid Email
    class func isValidEmail(withemail: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: withemail)
    }
    
    // MARK: -  Check valid Password
    class func isValidPassWord(password: String) -> Bool
    {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: password)
        if(isMatched  == true)
        {
            //  Show Success Message.
            return true
        }
        else
        {
            // Show Error Message.
            return false
        }
    }
    
    // MARK: - Check valid integer
    class func isValid(contryId: String) -> String{
        let countryID : Int? = Int(contryId)
        guard let country = countryID else { return String(0) }
        return String(country)
    }
    // MARK: - Check valid integer
    class func isStringAnInt(string: String) -> Bool
    {
        return Int(string) != nil
    }
    
    // MARK: - Print Global Line
    class func println(object: Any)
    {
        print(object)
    }
    
    // MARK: - AppDelegate Reference
    class func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - textField Bottom Underline
    class func textFieldBottomUnderline(textField : UITextField)
    {
        textField.layoutIfNeeded()
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.yellow.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :textField.frame.size.height - borderWidth), size: CGSize(width: textField.frame.size.width, height: textField.frame.size.height))
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    // MARK: - set colorCode from hexaString
    class func hexStringToUIColor (hex:String, alphaValue:CGFloat) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alphaValue
        )
    }
    // MARK: - label BorderWidth
    class func BorderWidth(array : NSArray)
    {
        for case let label as UILabel in array
        {
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.black.cgColor
        }
    }
    // MARK: - getDate From String
    class func getDateFromString(dateString : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.date(from: dateString)!
    }
    
    
    // MARK: - set LabelBorder
    class func setLabelBorder(view : UIView)
    {
        for case let label as UILabel in view.subviews
        {
            if label.tag == 1
            {
                label.layer.borderWidth = 1.0
                label.layer.borderColor = UIColor.black.cgColor
                label.font = label.font.withSize(13.5)
            }
        }
    }
    
    // MARK: - set Corner Radius For TextField
    class func setCornerRadiusForTextField(view : UIView)
    {
        for case let textField as UITextField in view.subviews
        {
            if textField.tag == 1
            {
                textField.layoutIfNeeded()
                textField.layer.cornerRadius = textField.frame.size.height/2
            }
        }
    }
    
    // MARK: - set Corner Radius For UIButton
    class func setCornerRadiusForUIButton(view : UIView)
    {
        for case let button as UIButton in view.subviews
        {
            if button.tag == 2
            {
                button.layoutIfNeeded()
                button.layer.cornerRadius = button.frame.size.height/2
            }
        }
    }
    
    // MARK: - set Corner Radius For UIImageView
    class func setCornerRadiusForUIImageView(Imageview : UIImageView)
    {
        Imageview.layoutIfNeeded()
        Imageview.layer.cornerRadius = Imageview.frame.size.height/2;
        Imageview.layer.masksToBounds = true
    }
    
    
    
    
    /*
     // MARK: - set Label left Alignment Space
     class func setLabelAlignmentWithSpace(view : UIView)
     {
     for case let label as UIMarginLabel in view.subviews
     {
     if label.tag == 1
     {
     label.layer.borderWidth = 1.0
     label.layer.borderColor = UIColor.black.cgColor
     label.rightInset = 10
     view.layoutIfNeeded()
     }
     else if label.tag == 2
     {
     label.layer.borderWidth = 1.0
     label.layer.borderColor = UIColor.black.cgColor
     label.leftInset = 5
     view.layoutIfNeeded()
     }
     }
     } */
    
    // MARK: - Case Insensitive Contains String
    class func caseInsensitiveContainsString(string : String) -> Bool
    {
        if string.localizedCaseInsensitiveContains(string)
        {
            return true
        }else
        {
            return false
        }
    }
    
    /*
     
     // MARK: -  Contains String in Model Array
     class func ContainsStringinArray(string : String , Arrlist : Array<Any>) -> Bool
     {
     let ProjectExists = Arrlist.contains(where:
     {
     // ($0.Subject.caseInsensitiveCompare(string) == ComparisonResult.orderedSame)
     ($0 as! mailSchemaDetailsModel).Subject.range(of: string, options: .caseInsensitive) != nil
     })
     return ProjectExists
     }
     // MARK: -  IndexOf String in Model Array
     class func IndexOfStringinArray(string : String , Arrlist : Array<Any>) -> Int
     {
     return Arrlist.index(where: { ($0 as! mailSchemaDetailsModel).Subject == string })!
     }
     //MARK : - RemoveDuplicateFromModelObject
     class func RemoveDuplicateFromModelObject(){
     
            var uniqueValues = Set<String>()
             arrParkedVehiclesGuestType = arrParkedVehiclesGuestType.filter{ uniqueValues.insert("\($0.guestTypeDesc)|\($0.guestTypeId)").inserted}
     }
     
     */
    
    // MARK: - Get Random Color
    class func getRandomColor() -> UIColor
    {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    // convert images into base64 and keep them into string
    class func convertImageToBase64(image: UIImage) -> String
    {
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)
        return dataImage
        
    }
    
    class func convertBase64ToImage(base64String: String) -> UIImage
    {
        let dataDecode:NSData = NSData(base64Encoded: base64String, options:.ignoreUnknownCharacters)!
        let avatarImage:UIImage = UIImage(data: dataDecode as Data)!
        return avatarImage
    }
    
    
    // MARK: - Image Resize Methods
    
    class func resizeImage(image : UIImage) -> UIImage
    {
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 300.0
        let maxWidth : CGFloat = 300.0
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        let compressionQuality : CGFloat = 0.3; //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            
            if imgRatio < maxRatio {
                
                //  Adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
                
            } else if imgRatio > maxRatio {
                
                //  Adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
                
            } else {
                
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rectSize : CGRect = CGRect(x:0.0, y:0.0, width:actualWidth, height:actualHeight)
        UIGraphicsBeginImageContext(rectSize .size)
        image .draw(in: rectSize)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData : NSData = UIImageJPEGRepresentation(img, compressionQuality)! as NSData
        UIGraphicsEndImageContext()
        
        let finalImage : UIImage = UIImage (data: imageData as Data)!
        
        return finalImage
    }

}


// MARK: - Device Chart Properties
extension SharedInstance
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(SCREEN_WIDTH, SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(SCREEN_WIDTH, SCREEN_HEIGHT)
    static let IPHONE_4  = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
    static let IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
    static let IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
    static let IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
    static let IPAD              = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
    static let IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0
    
}
// MARK: - Shake animation for UITextField
/*
extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
*/



