//
//  Api.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class API: NSObject {

    class func callRequest(completion: @escaping (_ error: Error?, _ success: Bool,_ model: Model?)->Void) {
        let url = "https://api.androidhive.info/contacts/"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false,nil)
                case .success( _):
                    
                    if let jsonData = response.data
                    {
                        let json = JSON(jsonData)
                        let model = Model(json:json)
                        completion (nil,true,model)
                    }
                }
           }
        }
    
   
 
    
    
}
