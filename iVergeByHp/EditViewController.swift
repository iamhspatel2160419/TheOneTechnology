//
//  EditViewController.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//

import UIKit
protocol passData :  class {
    func setData(contact:Contact,index:Int)
}

class EditViewController: UIViewController {
    
    var contact : Contact!
    var index:Int!
    
    weak var delegate:passData?
    
    @IBOutlet weak var txtFieldName: UITextField!
    
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    
    @IBOutlet weak var txtFieldNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldName.text = contact.name
        txtFieldEmail.text = contact.email
        txtFieldNumber.text = contact.home
    }
    
    
    @IBAction func saveDb(_ sender: Any) {
        
        let predicate = NSPredicate(format: "cid = %@ ",contact.cid ?? "")
        DbManager.sharedDbManager.fetchDataFromTableWithId("Contact",
                                                           strPredicate: predicate)
        { (result) in
            if result.count > 0
            {
                let result = result[0] as! Contact
                result.name = txtFieldName.text
                result.email = txtFieldEmail.text
                result.mobile = txtFieldNumber.text
                DispatchQueue.main.async {
                    let appdel = UIApplication.shared.delegate as! AppDelegate
                    do
                    {
                        try appdel.managedObjectContext.save()
                        if (self.delegate != nil)
                        {
                            self.delegate!.setData(contact: result, index: self.index)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    catch( _)
                    {
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
}
