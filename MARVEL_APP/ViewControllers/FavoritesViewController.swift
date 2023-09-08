//
//  FavoritesViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 20.07.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var myFavoriteComics: [String:Int] = [:]
    var myFavoriteCharacters: [String:Int] = [:]
    var whichOne:String = "Heroes"
    
    @IBOutlet weak var FavoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        initTable()
        initFavorites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.items?[1].badgeValue = nil
        
        initFavorites()
        FavoritesTableView.reloadData()
    }
   
    
    @IBAction func HeroesFavoriteAction(_ sender: Any) {
        whichOne = "Heroes"
        FavoritesTableView.reloadData()
    }
    

    @IBAction func ComicsFavoriteAction(_ sender: Any) {
            whichOne = "Comics"
        FavoritesTableView.reloadData()
    }
    
     private func initTable(){
         FavoritesTableView.dataSource = self
         FavoritesTableView.delegate   = self
     }
     
     private func initFavorites(){
         let defaults = UserDefaults.standard
         myFavoriteComics = defaults.object(forKey: "ComicsKey") as? [String:Int] ?? [:]
         myFavoriteCharacters = defaults.object(forKey: "HeroesKey") as? [String:Int] ?? [:]

         print(myFavoriteComics)
         print(myFavoriteCharacters)
     }
}



extension FavoritesViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        whichOne == "Heroes" ? myFavoriteCharacters.count : myFavoriteComics.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FavoritesTableView.dequeueReusableCell(withIdentifier: "MyFavoriteCell", for: indexPath) as! FavoritesTableViewCell
        whichOne == "Heroes" ? (cell.FavoriteNameLbl.text = Array(myFavoriteCharacters.keys)[indexPath.row])
        : (cell.FavoriteNameLbl.text = Array(myFavoriteComics.keys)[indexPath.row])


                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(whichOne == "Heroes"){
            let favoriteHeroValues = Array(myFavoriteCharacters.values)
            let selectedValue = favoriteHeroValues[indexPath.row]
            let myParams = HeroSearchIDParams(id: selectedValue)
            
            NetworkManager.shared.makeCharacterIDRequest(params:myParams
                                                         
            ) { myCharacterResult in
                
                switch myCharacterResult{
                case .success(let result):
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HeroDetailPage") as? HeroesDetailPageViewController else {
                        return
                    }
                    vc.hero = result?.data?.results?.first
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .failure(let error):
                    print("favoritesView did Select error :\(error)")
                    
                }
                
                
            }
        }else{
            let favoriteComicsValues = Array(myFavoriteComics.values)
            let selectedValue = favoriteComicsValues[indexPath.row]

            NetworkManager.shared.makeComicSearchOnlyIDRequest(params: ComicSearchOnlyIDParams(id: selectedValue)) { myComicResult in
                switch myComicResult{
                case .success(let Comic):
                    
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ComicDetailPage") as? ComicsDetailViewController else {
                        return
                    }
                    vc.myComic = Comic?.data?.results?.first
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    break
                    
                case .failure(let error):
                    print("error is in FavoritesExt \(error)")
                    break
                    
                    
                }

            }
        }
    }
    
}
