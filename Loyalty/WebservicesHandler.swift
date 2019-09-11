//
//  WebservicesHandler.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 13/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class WebservicesHandler: NSObject
{
    
    // MARK: - Singleton Declaration
    static var sharedInstance = WebservicesHandler()
    
    
    
    // MARK: - Service Dev URL
    //  static var serviceRootURL = "http://cipldev.com/ventre/business/webservice/"
    
    // MARK: - Service Live URL
     static var serviceRootURL = "https://ventre.xyz/business/webservice/"
    
    // MARK: - Service URL Identfier
    var termsOfServices = "https://ventre.xyz/Terms"
    
    
    
    // MARK: - logIn ServiceCall
    class func logInServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)login"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
        
    }
    
    // MARK: - signUP ServiceCall
    class func signUPServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)register"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
             ErrorCompletion("Make sure your device is not connected to the internet...")
        }
        
    }
    // MARK: - Reset Password ServiceCall
    class func resetPasswordServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)ForgotPassword"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }

    
    // MARK: - Edit Profile ServiceCall
    class func editProfileServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)EditProfile"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }

    // MARK: - Update Password ServiceCall
    class func updatePasswordServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)ChangePassword"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }
    
    // MARK: - ListData ServiceCall
 
    class func listDataServiceCall(serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)Listing"
            
            print("Home URL",urlString)
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }

       
    // MARK: - Detail Listing ServiceCall
    class func detailsListingServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)ListingInfo"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }
    
    // MARK: - search Listing ServiceCall
    class func searchListingServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)SearchListing"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }
    
    // MARK: - GenerateUPC  ServiceCall
    class func GenerateUPCServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)GenerateUPC"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }
    // MARK: - Paypal Success ServiceCall
    class func payPalSuccessServiceCall (serviceRequestParameters : NSDictionary,onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ serviceResponse : String) -> Void)
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            let urlString = "\(serviceRootURL)PaymentSuccess"
            
            Webservices.postMethodServiceCall(serviceURLString: urlString as NSString,serviceRequestParameters:serviceRequestParameters ,onCompletion: {(serviceResponse)in
                
                onCompletion(serviceResponse)
                
            }, ErrorCompletion: {(Message)in
                
                ErrorCompletion(Message)
            })
        }
        else
        {
            ErrorCompletion("Make sure your device is not connected to the internet...")
        }
    }
   
}
