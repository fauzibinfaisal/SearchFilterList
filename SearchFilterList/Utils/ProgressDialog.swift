//
//  ProgressDialog.swift
//  SearchFilterList
//
//  Created by Infotech Solutions on 22/11/21.
//

import UIKit

class ProgressDialog {
    var progressView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
    var activityIndicator = UIActivityIndicatorView()
    var isShown = false
    
    static let shared = ProgressDialog()
    
    private init() {}
    
    func show(view: UIView) {
        if !isShown {
            var vw = view
            if let app = UIApplication.shared.delegate, let window = app.window {
                vw = window!
            }
            progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            progressView.center = vw.center
            progressView.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 0.5)
            progressView.clipsToBounds = true
            progressView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            if #available(iOS 13.0, *) {
                activityIndicator.style = UIActivityIndicatorView.Style.large
            } else {
                activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            }
            activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
            
            progressView.contentView.addSubview(activityIndicator)
            vw.addSubview(progressView)
            isShown = true
            activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.progressView.removeFromSuperview()
            self?.isShown = false
        }
    }
}
