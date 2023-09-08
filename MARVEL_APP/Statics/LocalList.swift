//
//  LocalList.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 20.07.2023.
//

import Foundation


class MyLocalVeriables{
    static var allMyFavoriteHeroes:[String:Int] = {
        return UserDefaults.standard.object(forKey: "HeroesKey") as? [String:Int] ?? [:]
    }()
    static var allMyFavoriteComics:[String:Int] = {
        return UserDefaults.standard.object(forKey: "ComicsKey") as? [String:Int] ?? [:]
    }()
}



