//
//  Model.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//
import Foundation
import SwiftyJSON

class Model:NSObject
{
    var list = [Item]()
    init?(json: JSON)
    {   super.init()
        if let contacts = json["contacts"].array
        {
            for contact in contacts {
                let id = contact["id"].string ?? "-"
                let name = contact["name"].string ?? "-"
                let email = contact["email"].string ?? "-"
                let address = contact["address"].string ?? "-"
                let gender = contact["id"].string ?? "-"
                
                let mobile = contact["phone"]["mobile"].string ?? "-"
                let home = contact["phone"]["home"].string ?? "-"
                let office = contact["phone"]["office"].string ?? "-"
                
                let element = Item(id: id, name: name, email: email, address: address, gender: gender, mobile: mobile, home: home, office: office)
                list.append(element)
            }
        }
    }
}


struct Item {
    var id:String
    var name:String
    var email:String
    var address:String
    var gender:String
    var mobile:String
    var home:String
    var office:String
}

//{
//    "contacts": [
//        {
//                "id": "c200",
//                "name": "Ravi Tamada",
//                "email": "ravi@gmail.com",
//                "address": "xx-xx-xxxx,x - street, x - country",
//                "gender" : "male",
//                "phone": {
//                    "mobile": "+91 0000000000",
//                    "home": "00 000000",
//                    "office": "00 000000"
//                }
//        },
