//
//  UIViewExt.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: Default Corner Radius
    func setDefaultCornerRadius(){
        layer.cornerRadius = 8
    }
    
    // MARK: Default Border Cell
    func setDefaultBorderCell(){
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "BorderCell")?.cgColor
        layoutIfNeeded()
    }
    
    // MARK: Default Border
    func setDefaultBorder(){
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "PrimaryRed")?.cgColor
        layoutIfNeeded()
    }
    
    // MARK: Default Border Button
    func setDefaultBorderButton(){
        layer.cornerRadius = 8
        layoutIfNeeded()
    }
    
    func loopDescendantViews(_ closure: (_ subView: UIView) -> Void) {
        for v in subviews {
            closure(v)
            v.loopDescendantViews(closure)
        }
    }
}
