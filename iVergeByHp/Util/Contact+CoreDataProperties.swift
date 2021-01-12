//
//  Contact+CoreDataProperties.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var cid: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var gender: String?
    @NSManaged public var mobile: String?
    @NSManaged public var home: String?
    @NSManaged public var office: String?

}

extension Contact : Identifiable {

}
