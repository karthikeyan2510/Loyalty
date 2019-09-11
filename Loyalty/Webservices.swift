//
//  Webservices.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 13/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class Webservices: NSObject
{

    // MARK: - GET Methods Service
    class func getMethodServiceCall (serviceURLString : NSString, onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ Message : String) -> Void)
    {
        
        let serviceString = NSString (string: serviceURLString)
        let serviceURL = NSURL (string: serviceString as String)
        let serviceURLRequest = NSMutableURLRequest (url: serviceURL! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 25)
        serviceURLRequest .httpMethod = "GET"
        serviceURLRequest .addValue("application/json", forHTTPHeaderField: "Content-Type")
        serviceURLRequest .addValue("application/json", forHTTPHeaderField: "Accept")
        serviceURLRequest .addValue("text/html", forHTTPHeaderField: "Accept")
        let serviceURLSession = URLSession .shared
        let serviceURLSessionDataTask = serviceURLSession .dataTask(with: serviceURLRequest as URLRequest, completionHandler: {(serviceURLData, serviceURLResponse, serviceURLError) in
        let httpResponse = serviceURLResponse as? HTTPURLResponse
            
            if httpResponse?.statusCode == 200
            {
                if serviceURLError != nil
                {
                    ErrorCompletion(serviceURLError! .localizedDescription)
                    
                } else
                {
                    do
                    {
                        let serviceResponse = try JSONSerialization .jsonObject(with: serviceURLData!, options: JSONSerialization.ReadingOptions .allowFragments)
                       
                        onCompletion (serviceResponse as AnyObject)
                        
                    } catch
                    {
                        ErrorCompletion("Cannot convert json from service data")
                        _ = String(data: serviceURLData!, encoding: String.Encoding.utf8) as String!
                       // print(backToString ?? "")
                    }
                }
            }else
            {
                ErrorCompletion("Service Responce Code - \(httpResponse?.statusCode)")
            }
        })
        serviceURLSessionDataTask .resume()
        
    }
    
    
    // MARK: - POST Methods Service 
    class func postMethodServiceCall (serviceURLString : NSString, serviceRequestParameters : AnyObject, onCompletion : @escaping (_ serviceResponse : AnyObject) -> Void,ErrorCompletion : @escaping (_ Message : String) -> Void)
    {
        
        let serviceString = NSString (string: serviceURLString)
        let serviceURL = NSURL (string: serviceString as String)
        let serviceURLRequest = NSMutableURLRequest (url: serviceURL! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 25)
        serviceURLRequest .httpMethod = "POST"
        serviceURLRequest .addValue("application/json", forHTTPHeaderField: "Content-Type")
        serviceURLRequest .addValue("application/json", forHTTPHeaderField: "Accept")
        serviceURLRequest .addValue("text/html", forHTTPHeaderField: "Accept")
        do
        {
            serviceURLRequest .httpBody = try JSONSerialization .data(withJSONObject: serviceRequestParameters, options: JSONSerialization.WritingOptions .prettyPrinted)
        } catch
        {
             ErrorCompletion("Cannot parse json data")
        }
        
        let serviceURLSession = URLSession .shared
        let serviceURLSessionDataTask = serviceURLSession .dataTask(with: serviceURLRequest as URLRequest, completionHandler: {(serviceURLData, serviceURLResponse, serviceURLError) in
            let httpResponse = serviceURLResponse as? HTTPURLResponse
            
            if httpResponse?.statusCode == 200
            {
                if serviceURLError != nil
                {
                    ErrorCompletion(serviceURLError! .localizedDescription)
                    
                } else
                {
                    do
                    {
                        let serviceResponse = try JSONSerialization .jsonObject(with: serviceURLData!, options: JSONSerialization.ReadingOptions .allowFragments)
                        onCompletion (serviceResponse as AnyObject)
                    } catch
                    {
                        ErrorCompletion("Cannot convert json from service data")
                        
                       _ = String(data: serviceURLData!, encoding: String.Encoding.utf8) as String!
                      //  print(backToString ?? "")
                    }
                }
            }
            else
            {
               ErrorCompletion("Service responce status code - \(httpResponse?.statusCode)")
            }
        })
        serviceURLSessionDataTask .resume()
    }
}
