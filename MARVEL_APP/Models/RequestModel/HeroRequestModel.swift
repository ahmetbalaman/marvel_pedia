//
//  HeroRequestModel.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 10.08.2023.
//

import Foundation

struct HeroRequestParams{
    var nameStartsWith:String
    var orderBy:String
    let limit:Int
    let offset:Int
    let doesHaveName:Bool?
    init(
        nameStartsWith:String="none",
        orderBy:String = "name",
        limit:Int = 30,
        offset:Int = 0,
        doesHaveName:Bool = false
    ) {
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
        self.doesHaveName = doesHaveName
        self.orderBy = orderBy
        self.nameStartsWith =  nameStartsWith
    }
}
struct HeroSearchStartsWithParams{
    let nameStartsWith:String?
   
    let limit:Int
    let offset:Int
    
    init(nameStartsWith: String?,limit:Int = 30, offset:Int = 0) {
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
    }
   
}
struct HeroSearchIDParams{
    let id: Int?
}
