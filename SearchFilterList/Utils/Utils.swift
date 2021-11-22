//
//  Utils.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation
import UIKit

class Utils {
    static let shared = Utils()
    
    func showAlert(_ title: String, message: String, parent: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            parent.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(_ title: String, message: String, withAction action:
        UIAlertAction, parent: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(action)
            parent.present(alert, animated: true, completion: nil)
        }
    }
    
}
