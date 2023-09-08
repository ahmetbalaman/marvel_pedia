//
//  OrderByItems.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 3.08.2023.
//

import Foundation

enum HeroOrderByItems:String{
    case name = "Name(A...Z)"
    case nameReverse = "Name(Z...A)"
    case modified = "Modified Date"
    case modifiedReverse = "Modified Date(Reverse)"
    var whichOne: String{
        switch self{
        case .name:
            return "name"
        case .nameReverse:
            return "-name"
        case .modified:
            return "modified"
        case .modifiedReverse:
            return "-modified"
        }
    }
}

enum ComicOrderByItems: String {
    case focDate = "FOC Date"
    case onSaleDate = "On Sale Date"
    case title = "Title     "
    case issueNumber = "Issue Number"
    case modified = "Modified Time"
    
    case focDateReverse = "FOC Date Reverse"
    case onSaleDateReverse = "On Sale Date Reverse"
    case titleReverse = "Title Reverse"
    case issueNumberReverse = "Issue Number Reverse"
    case modifiedReverse = "Modified Time Reverse"
    var whichOne: String{
        switch self{
        case .focDate:
            return "focDate"
        case .onSaleDate:
            return "onsaleDate"
        case .title:
            return "title"
        case .issueNumber:
            return "issueNumber"
        case .modified:
            return "modified"
        case .focDateReverse:
            return "-focDate"
        case .onSaleDateReverse:
            return "-onsaleDate"
        case .titleReverse:
            return "-title"
        case .issueNumberReverse:
            return "-issueNumber"
        case .modifiedReverse:
            return "-modified"

        }
        
    }
    
}
