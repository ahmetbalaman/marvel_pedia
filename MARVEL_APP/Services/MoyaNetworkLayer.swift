//
//  MoyaNetworkLayer.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 27.07.2023.
//


import Foundation
import Moya

enum MoyaNetworkLayer{
    
    // MARK: Hero
    case makeHeroOrderByRequest(params:HeroRequestParams)
    case MakeHeroSearchStartsWithRequest(params:HeroSearchStartsWithParams)
    case MakeHeroSearchIDRequest(params: HeroSearchIDParams)
    
    // MARK: Comic
    case makeComicSearchTitleStartsWithRequest(params:ComicSearchStartsWithParams)
    case makeComicSearchOnlyIDRequest(params:ComicSearchOnlyIDParams)
    case makeComicHeroSearchRequest(params:ComicHeroSearchParams)
}
extension MoyaNetworkLayer: TargetType{
    var baseURL: URL {
        guard let url = URL(string: "http://gateway.marvel.com/v1/public/")  else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .makeHeroOrderByRequest, .MakeHeroSearchStartsWithRequest:
            return "characters"
        case .MakeHeroSearchIDRequest(params:let makeHeroIDParams):
            return "characters/\(makeHeroIDParams.id!)"
        case .makeComicSearchTitleStartsWithRequest, .makeComicSearchOnlyIDRequest, .makeComicHeroSearchRequest:
            return "comics"
        }
    }
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        let params: [String: Any] = ["ts": Const.TS, "apikey": Const.API_KEY, "hash": Const.HASH]
            
        switch self {
            case .makeHeroOrderByRequest(params:let makeHeroRequestParams):
        
            let myParams = params.merging(
                [
                    "offset":makeHeroRequestParams.offset,
                    "limit":makeHeroRequestParams.limit
                ], uniquingKeysWith: { $1 })
                
        return  .requestParameters(parameters:
                                    myParams.merging(
                    
                    makeHeroRequestParams.doesHaveName! ?  [
                        "orderBy": makeHeroRequestParams.orderBy,
                        "nameStartsWith":makeHeroRequestParams.nameStartsWith
                    ] :
                        [
                            "orderBy": makeHeroRequestParams.orderBy
                        ]
                    , uniquingKeysWith: { $1 }), encoding: URLEncoding.queryString)
                
                
            case .MakeHeroSearchStartsWithRequest(params:let makeHeroSearchStartsWithParams):
                
                let myParams = params.merging(
                    [
                        "offset":makeHeroSearchStartsWithParams.offset,
                        "limit":makeHeroSearchStartsWithParams.limit,
                        "nameStartsWith": makeHeroSearchStartsWithParams.nameStartsWith!
                    ], uniquingKeysWith: { $1 })
             
                return .requestParameters(parameters: myParams, encoding: URLEncoding.queryString)
                
            case .makeComicSearchTitleStartsWithRequest(params:let ComicSearchStartsWithParams):
                
                let myParams = params.merging(
                    [
                        "offset":ComicSearchStartsWithParams.offset,
                        "limit":ComicSearchStartsWithParams.limit
                    ], uniquingKeysWith: { $1 })
                return
                    .requestParameters(
                        parameters:
                            myParams.merging(
                                [
                                    "orderBy": ComicSearchStartsWithParams.orderBy,
                                    "titleStartsWith":ComicSearchStartsWithParams.titleStartsWith
                                ]
                                , uniquingKeysWith: { $1 }), encoding: URLEncoding.queryString)
                
            case .makeComicSearchOnlyIDRequest(params:let ComicSearchOnlyIDParams):
                return .requestParameters(parameters: params.merging(
                    [
                        "id": ComicSearchOnlyIDParams.id
                    ], uniquingKeysWith: { $1 }), encoding: URLEncoding.queryString)
            case .makeComicHeroSearchRequest(params:let ComicHeroSearchParams):
                return .requestParameters(parameters: params.merging(
                    [
                        "characters": ComicHeroSearchParams.characterID
                    ], uniquingKeysWith: { $1 }), encoding: URLEncoding.queryString)
            default:
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        
    }
    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
