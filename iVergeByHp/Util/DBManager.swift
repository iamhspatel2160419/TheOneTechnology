//
//  DBManager.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//

import UIKit
import CoreData

open class DbManager
{
    static let sharedDbManager = DbManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init()
    {
        
    }
    var dictAttributes : NSDictionary!
    
    func insertIntoTable(_ tblName:String,
                         dictInsertData:NSDictionary,
                         completion: @escaping (Bool)->(Void))
    {
        let managedObject  = NSEntityDescription.insertNewObject(forEntityName: tblName, into: appDelegate.managedObjectContext)
        let entity = managedObject.entity
        dictAttributes = entity.attributesByName as NSDictionary
        for (key, _) in dictAttributes
        {
            var entityValue : AnyObject
            let tempKey = (key as!String).firstCharacterUpperCase()
            if let val = dictInsertData.object(forKey: key)
            {
                entityValue = val as AnyObject
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
                
            }
            else if ((dictInsertData[tempKey]) != nil )
            {
                entityValue = dictInsertData.object(forKey: tempKey)! as AnyObject
                if entityValue is NSNull
                {
                    
                }
                else
                {
                    managedObject.setValue(entityValue, forKey: key  as! String)
                }
            }
        }
        do
        {
            let appdel = UIApplication.shared.delegate as! AppDelegate
            try appdel.managedObjectContext.save()
            return completion(true)
            
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
            return completion(false)
        }
        
    }

    func fetchDataFromTable(_ tbleName:String,
                            completion: (_ result: NSArray)->())
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            completion(results as NSArray)
            //print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func fetchData(_ tbleName:String,
                            completion: (_ result: NSArray)->())
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            completion(results as NSArray)
            //print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func clearTable(_ entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
            
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    func fetchDataFromTableWithId(_ tbleName:String,
                               strPredicate:NSPredicate,
                               completion: (_ result: NSArray)->())
       {
           let appDelegate =
               UIApplication.shared.delegate as! AppDelegate
           let managedContext = appDelegate.managedObjectContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tbleName)
           fetchRequest.predicate = strPredicate
           fetchRequest.returnsObjectsAsFaults = false
           do {
               let results =
                   try managedContext.fetch(fetchRequest)
               completion(results as NSArray)
               //print(results)
           } catch let error as NSError {
               print("Could not fetch \(error), \(error.userInfo)")
           }
       }
    func deleteSelectedId(_ entity: String,strPredicate:String,completion:  (Bool)->(Void))
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if !strPredicate.isEmpty
        {
            fetchRequest.predicate = NSPredicate(format: strPredicate)
        }
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            for manageObjects in results {
                appDelegate.managedObjectContext.delete(manageObjects as! NSManagedObject)
                try appDelegate.managedObjectContext.save()
                //print(manageObjects)
            }
             completion(true)
        } catch let error as NSError
        {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
             completion(false)
        }
    }
    
}

extension String
{
   func firstCharacterLowerCase() -> String
    {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.lowercased() + rest
    }
    
    func firstCharacterUpperCase() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest
    }
    
    func trimString() -> String {
        return self.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
 
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
