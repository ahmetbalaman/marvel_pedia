//
//  MyColors.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 14.07.2023.
//

import UIKit



enum MyColorProfile {
case primary
case secondary


var uiColor: UIColor {
    switch self {
    case .primary:
        return .systemBackground
    case .secondary:
        return .systemRed
    
    }
}
}
