//
//  LoadService.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 10.08.2023.
//

import Foundation
import UIKit


let overlayView = UIView()
let activityIndicator = UIActivityIndicatorView(style: .large)


func showOverlay() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let keyWindow = windowScene.windows.first {
        overlayView.frame = keyWindow.bounds
        overlayView.center = CGPoint(x: keyWindow.frame.width / 2.0, y: keyWindow.frame.height / 2.0)
        overlayView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

        overlayView.addSubview(activityIndicator)
        keyWindow.addSubview(overlayView)

        activityIndicator.startAnimating()
    }
}
func hideOverlay(){
    overlayView.removeFromSuperview()
        activityIndicator.stopAnimating()
}
