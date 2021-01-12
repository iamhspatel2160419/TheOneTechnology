//
//  CustomInfoWindow.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//

import UIKit

class CustomInfoWindow: UIView {

    var url = ""
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblBusinessAddress: UILabel!
    
    @IBAction func websiteBtnTapped(_ sender: UIButton) {
        if let url = URL(string: url) {
                if #available(iOS 10, *){
                    UIApplication.shared.open(url)
                }else{
                    UIApplication.shared.openURL(url)
                }

            }
    }
    
    @IBOutlet weak var lblWebsiteName: UILabel!
    @IBAction func callBtnTapped(_ sender: Any) {
    }
    override init(frame: CGRect) {
     super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
    }
    func loadView() -> CustomInfoWindow{
     let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
     return customInfoWindow
    }

}
