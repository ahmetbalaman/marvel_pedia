//
//  UIImageView+Ext.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 28.07.2023.
//

import Foundation
import UIKit

extension UIImageView{
    //MARK: - IBInspectable
    
    @IBInspectable var borderWidth : CGFloat {
          set {
              layer.borderWidth = newValue
          }
          get {
              return layer.borderWidth
          }
      }
    
    @IBInspectable var cornerRadius : CGFloat {
          set {
              layer.cornerRadius = newValue
          }
          get {
              return layer.cornerRadius
          }
      }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    
    
    //MARK: - Funcs
    func addDownToUpGradient(){
        //Setting the gradient
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.4)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(0.2).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.frame = bounds
        layer.mask = gradient
    }
    
}



