//
//  PopUpMenuItems.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 3.08.2023.
//

import Foundation
import UIKit
import OrderedCollections

//let ComicPopUpMenuItems:[ComicOrderByItems:String] = [
//    .titleReverse:"book.fill",
//    .title:"book",
//    .modifiedReverse:"clock.fill",
//    .modified:"clock",
//    .onSaleDateReverse:"dollarsign.circle.fill",
//    .onSaleDate:"dollarsign.circle",
//    .issueNumberReverse:"number.square.fill",
//    .issueNumber:"number",
//    .focDateReverse:"calendar.badge.minus",
//    .focDate:"calendar.badge.plus",]
//

let ComicPopUpMenuItems:OrderedDictionary<ComicOrderByItems,String> = [
    .title:"book",
    .titleReverse:"book.fill",
    .modified:"clock",
    .modifiedReverse:"clock.fill",
    .onSaleDate:"dollarsign.circle",
    .onSaleDateReverse:"dollarsign.circle.fill",
    .issueNumber:"number",
    .issueNumberReverse:"number.square.fill",
    .focDate:"calendar.badge.plus",
    .focDateReverse:"calendar.badge.minus"]

let myPopUpHeroItems:OrderedDictionary<HeroOrderByItems,String> = [
    .name:"person.3",
    .nameReverse:"person.3.sequence.fill",
    .modified:"clock",
    .modifiedReverse:"clock.fill"
]

