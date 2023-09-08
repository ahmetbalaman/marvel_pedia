//
//  ComicRequestModel.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 10.08.2023.
//

import Foundation

struct ComicSearchStartsWithParams{
    let titleStartsWith:String
    let orderBy:String
    let limit:Int
    let offset:Int
    
    init(titleStartsWith: String,orderBy:String = "title",limit:Int = 30, offset:Int = 0) {
        self.titleStartsWith = titleStartsWith
        self.orderBy = orderBy
        self.limit = limit
        self.offset = offset
    }
   
}
struct ComicSearchOnlyIDParams{
    let id: Int
}
struct ComicHeroSearchParams{
    let characterID:Int
    let limit: Int
    let offset: Int
    
    init(characterID: Int, limit: Int=30, offset: Int=0) {
        self.characterID = characterID
        self.limit = limit
        self.offset = offset
    }
}
