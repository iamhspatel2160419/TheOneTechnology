
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarStoryboardView: UISearchBar!
    
    var searchTxt = ""
    var model:Model? = nil
    var contacts = [Contact]()
    var filteredModel_ = [Contact]()
    var idMovedToEdit = false
    var isFilteringBySearchText: Bool {
        return !searchTxt.isEmpty
    }
    
    var isFiltering: Bool {
        return self.filteredModel_.count > 0 ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "iVerge"
        tableView.delegate = self
        tableView.dataSource = self
        setUpSearchBarDesign()
        
    }
    @IBAction func getData(_ sender: UIButton) {
        DbManager.sharedDbManager.clearTable("Contact")
        
        contacts.removeAll()
        filteredModel_.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            API.callRequest {  (error, isDone, model) in
                if isDone
                {
                    if let Model = model
                    {
                        var count = 0
                        for i in 0..<Model.list.count
                        {
                            let _ContactData = NSMutableDictionary()
                            _ContactData.setValue(Model.list[i].id, forKey: "cid")
                            _ContactData.setValue(Model.list[i].name, forKey: "name")
                            _ContactData.setValue(Model.list[i].email, forKey: "email")
                            _ContactData.setValue(Model.list[i].address, forKey: "address")
                            _ContactData.setValue(Model.list[i].gender, forKey: "gender")
                            _ContactData.setValue(Model.list[i].mobile, forKey: "mobile")
                            _ContactData.setValue(Model.list[i].home, forKey: "home")
                            _ContactData.setValue(Model.list[i].office, forKey: "office")
                            DbManager.sharedDbManager.insertIntoTable("Contact",
                                                                      dictInsertData:
                                                                        _ContactData)
                            { _ in
                                count = count + 1
                            }
                        }
                        if count == Model.list.count
                        {
                            Helper.sharedHelper.showAlert("Data Set ", alertMessage: "Data inserted.. :)")
                        }
                    }
                }
            }
        }
        
       
    }
    
    fileprivate func readData() {
        contacts.removeAll()
        filteredModel_.removeAll()
        DbManager.sharedDbManager.fetchData("Contact")
        { (result) in
            if result.count > 0
            {
                for k in 0..<result.count
                {
                    contacts.append(result[k] as! Contact)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func readData(_ sender: UIButton) {
        readData()
    }
    
    
    func setUpSearchBarDesign()
    {
        searchBarStoryboardView.delegate = self
        searchBarStoryboardView.setShowsCancelButton(false, animated: false)
        searchBarStoryboardView.tintColor = .green
        searchBarStoryboardView.placeholder = "Search Header name"
        searchBarStoryboardView.searchBarStyle = .default
        searchBarStoryboardView.showsCancelButton = true
        searchBarStoryboardView.layer.borderWidth = 1
        searchBarStoryboardView.layer.borderColor = UIColor.clear.cgColor
        if #available(iOS 13, *) {
            
        }
        else
        {
            if let cancelButton : UIButton = searchBarStoryboardView.value(forKey: "_cancelButton") as? UIButton{
                cancelButton.isEnabled = true
            }
        }
    }
    
}
extension ViewController:UISearchBarDelegate
{
    // MARK: - Search Delegate Method Implementation
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarStoryboardView.setShowsCancelButton(false, animated: false)
        searchBarStoryboardView.text = ""
        searchTxt = ""
        filteredModel_.removeAll()
        tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBarStoryboardView.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.view.endEditing(true)
        searchBarStoryboardView.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchTxt = searchText
        self.filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        DispatchQueue.global(qos: .background).async
        {
            let value = searchText
            self.filteredModel_ = self.contacts.filter { Contact  -> Bool in
                return Contact.name!.contains(value) || Contact.email!.contains(value) || Contact.mobile!.contains(value)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}


extension ViewController : UITableViewDelegate,UITableViewDataSource,passData
{
    func setData(contact: Contact,index:Int) {
        
        if isFiltering && isFilteringBySearchText
        {
            filteredModel_[index] = contact
            
        }
        else if isFiltering
        {
            filteredModel_[index] = contact
            
        }
        else if isFilteringBySearchText
        {
            filteredModel_[index] = contact
            
        }
        else
        {
            contacts[index] = contact
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        idMovedToEdit = true
        let vc = self.storyboard?.instantiateViewController(identifier: "EditViewController") as! EditViewController
        vc.delegate = self
        vc.index = indexPath.row
        vc.contact = contacts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering && isFilteringBySearchText
        {
            return filteredModel_.count
        }
        else if isFiltering
        {
            return filteredModel_.count
        }
        else if isFilteringBySearchText
        {
            return filteredModel_.count
        }
        else
        {
            return contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CustomCell
        cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")! as! CustomCell
        var isFilter = false
        if isFiltering && isFilteringBySearchText
        {
            isFilter = true
        }
        else if isFiltering
        {
            isFilter = true
        }
        else if isFilteringBySearchText
        {
            isFilter = true
        }
        else
        {
            isFilter = false
        }
        let ele = isFilter ? filteredModel_[indexPath.row] : contacts[indexPath.row]
        cell.lblName.text = ele.name
        cell.lblEmail.text = ele.email
        cell.lblMobileNumber.text = ele.mobile
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 123
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if isFiltering && isFilteringBySearchText
            {
                filteredModel_.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if isFiltering
            {
                filteredModel_.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if isFilteringBySearchText
            {
                filteredModel_.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else
            {
                contacts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            
        }
    }
}




