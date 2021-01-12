//
//  Helper.swift
//  SynovergeByHp
//
//  Created by Apple on 21/12/20.
//

import Foundation
import CoreData
import AVFoundation
import UIKit

open class Helper : NSObject
{
    
    static let sharedHelper = Helper()
    
    override init()
    {
        
    }
    
    func getRootViewController() -> UIViewController?
      {
          if let topController = UIApplication.topViewController() {
              return topController
          }
          if let viewController =  UIApplication.shared.keyWindow?.rootViewController
          {
              return viewController
          }
          return nil
      }
      func showAlert(_ alertTitle: String, alertMessage: String)
      {
          if objc_getClass("UIAlertController") != nil
          { // iOS 8
              let myAlert: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
              myAlert.view.tintColor = customColor.globalTintColor
              myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.getRootViewController()?.present(myAlert, animated: true, completion: nil)
          }
          else
          {
              let alert: UIAlertView = UIAlertView()
              alert.delegate = self
              alert.title = alertTitle
              alert.tintColor = customColor.globalTintColor
              alert.message = alertMessage
              alert.addButton(withTitle: "OK")
              
              alert.show()
          }
      }
}
extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
struct customColor
{
    static let globalTintColor =  UIColor(red: 67.0/255.0, green: 141.0/255.0, blue: 65.0/255.0, alpha:1.0)
}
extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(string: documentsDirectory)!
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
