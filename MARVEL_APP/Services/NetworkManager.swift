//
//  JsonRequest.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 13.07.2023.
//

import Foundation
import Alamofire
import Moya
import UIKit


protocol Networkable{
    static var shared:NetworkManager { get }
    var prodiver: MoyaProvider<MoyaNetworkLayer>{ get }
    //MARK: HERO REQUESTS
    func makeAllHeroRequest(params:HeroRequestParams,doesHaveName:Bool, completion: @escaping (Result<CharacterJSON?,Error>) ->())
    func makeCharacterSearchRequest(params:HeroSearchStartsWithParams, completion: @escaping (Result<CharacterJSON?,Error>) ->())
    func makeCharacterIDRequest(params:HeroSearchIDParams , completion: @escaping (Result<CharacterJSON?, Error>) ->())
    //MARK: COMİC REQUESTS
    
    func makeAllComicSearchRequest(params:ComicSearchStartsWithParams,completion: @escaping (Result<ComicJSON?,Error>) -> ())
    func makeComicSearchRequest(params:ComicSearchStartsWithParams, completion: @escaping (Result<ComicJSON?,Error>) ->())
    func makeComicSearchOnlyIDRequest(params:ComicSearchOnlyIDParams , completion: @escaping (Result<ComicJSON?,Error>) ->())
    func makeComicCharacterSearchRequest(params:ComicHeroSearchParams, completion: @escaping (Result<ComicJSON?,Error>) -> ())
    func makeURLRequest(baseUri:String, completion: @escaping (ComicResult?) ->Void)
}



class NetworkManager:Networkable {
    public static var shared: NetworkManager = NetworkManager()
    var prodiver = MoyaProvider<MoyaNetworkLayer>()
    
    func makeAllHeroRequest(params:HeroRequestParams,doesHaveName:Bool, completion: @escaping (Result<CharacterJSON?,Error>) ->()) {
        request(target: .makeHeroOrderByRequest(params:params),completion: completion)
    }
    func makeCharacterSearchRequest(params:HeroSearchStartsWithParams, completion: @escaping (Result<CharacterJSON?,Error>) ->()) {
        request(target: .MakeHeroSearchStartsWithRequest(params:params),completion: completion)
    }
    func makeCharacterIDRequest(params:HeroSearchIDParams , completion: @escaping (Result<CharacterJSON?, Error>) ->()) {
        request(target: .MakeHeroSearchIDRequest(params:params), completion: completion)
    }
    
    func makeAllComicSearchRequest(params:ComicSearchStartsWithParams, completion: @escaping (Result<ComicJSON?,Error>) -> ())
    {
        request(target: .makeComicSearchTitleStartsWithRequest(params: params), completion: completion)
    }

    func makeComicSearchRequest(params:ComicSearchStartsWithParams, completion: @escaping (Result<ComicJSON?,Error>) ->()) {
        //buraya sonra bak
        request(target: .makeComicSearchTitleStartsWithRequest(params: params), completion: completion)
        
    }
    
    func makeComicSearchOnlyIDRequest(params:ComicSearchOnlyIDParams , completion: @escaping (Result<ComicJSON?,Error>) -> ()){
        request(target: .makeComicSearchOnlyIDRequest(params: params), completion: completion)
    }
    func makeComicCharacterSearchRequest(params:ComicHeroSearchParams, completion: @escaping (Result<ComicJSON?,Error>) -> ()){
        
        request(target: .makeComicHeroSearchRequest(params:params), completion: completion)
       
    }
    
    
    func makeURLRequest(baseUri:String, completion: @escaping (ComicResult?) ->Void) {
        let url = "\(String(describing: baseUri))?ts=\(Const.TS)&apikey=\(Const.API_KEY)&hash=\(Const.HASH)"
        AF.request(url).responseDecodable(of: ComicJSON.self) { response in
            switch response.result {
            case .success(let value):
                if let data = value.data{
                    if let results = data.results {
                        
                        completion(results.first) // Pass the results to the completion handler
                        return
                        
                    }}else{
                    completion(nil) // Pass nil if the results are not available
                }
    
                
            case .failure(let error):
                print("Error: \(error)")
                completion(nil) // Pass nil in case of failure
            }
        }
    }
}


 extension NetworkManager{
     func request<T: Decodable>(target: MoyaNetworkLayer, completion: @escaping (Result<T, Error>) -> ()) {
         showOverlay()
         self.prodiver.request(target) {
            result in
             
           
             print("*********bekliyor************")
            switch result{
            case .success(let response):
                
                do{
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    
                    completion(.success(results))
                }catch let error{
                    completion(.failure(error))
                }
                break
            case .failure(let error):
                print("error in \(target.baseURL)")
                print(error)
                break
            }
             hideOverlay()
             
             
        }
         
   }
    
}



// AF REQUEST


//AF.request(url).responseDecodable(of: CharacterJSON.self) { response in
//            switch response.result {
//            case .success(let value):
//                if let data = value.data {
//                    if let results = data.results {
//                        completion(results) // Pass the results to the completion handler
//                        return
//                    }
//                }
//
//                completion(nil) // Pass nil if the results are not available
//
//            case .failure(let error):
//                print("Error: \(error)")
//                completion(nil) // Pass nil in case of failure
//            }
//        }
