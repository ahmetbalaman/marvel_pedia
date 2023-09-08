//
//  ComicCharacterSearchViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 20.07.2023.
//

import UIKit

class ComicCharacterSearchViewController: UIViewController {
    //MARK: Veriables
    var myCharacterResult:     [CharactersResult]?  = []
    var myCharacterComicResult:[ComicResult]?       = []
    var noData:                Bool                 = false
    @IBOutlet weak var ComicSearchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        getComicSearchList()
    }
    //MARK: Functions
    
    func initTable(){
        ComicSearchCollectionView.delegate = self
        ComicSearchCollectionView.dataSource = self
    }
    
    func getComicSearchList(){
        var ListOfHeroesName = [String]()
        myCharacterResult?.forEach({ CharactersResult in
            ListOfHeroesName.append(CharactersResult.name!)
        })
        myCharacterResult?.forEach({ CharactersResult in
            NetworkManager.shared.makeComicCharacterSearchRequest(params:ComicHeroSearchParams(characterID: CharactersResult.id ?? 0)) { ComicsResults in
                    switch ComicsResults{
                    case .success(let comics):
                        comics?.data?.results?.forEach({ ComicResult in
                                let characterNames = ComicResult.characters?.items?.compactMap { $0.name }
                                if let characterNames = characterNames, Set(ListOfHeroesName).isSubset(of: Set(characterNames)) {
                                    self.myCharacterComicResult?.append(ComicResult)
                                   }
                              
                        })
                        self.ComicSearchCollectionView.reloadData()
                        // if it isnt find any match
                        if(self.myCharacterComicResult!.isEmpty){
                            self.noData = true
                        }
                        break
                        
                    case .failure(let error):
                        print("Error is in getComicSearchList \(error)")
                    }
                    
                 
                }
            
        })


       //Referans mantık
//        var idler: [Int] = [1010801, 1010803]
//
//        dizi?.forEach { comics in
//            let characterIds = comics.character?.compactMap { $0.id }
//            if let characterIds = characterIds, Set(idler).isSubset(of: Set(characterIds)) {
//                print(comics.comicName ?? "")
//            }
//        }

    }
}



//MARK: Extension UICollectionView
extension ComicCharacterSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( noData ){
                        return 1
        }
        return  myCharacterComicResult?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.ComicSearchCollectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as! MyCollectionCell
        if(noData){
            
            cell.ComicImage.image = UIImage(systemName: "nosign")
            cell.ComicImage.tintColor = .red
            cell.ComicLbl.text = "This Characters Doesn't have Comics Together"
        }else{
           
            
            if myCharacterComicResult?[indexPath.row].thumbnail != nil {
            setTheImage(image: cell.ComicImage, myPhoto: (myCharacterComicResult![indexPath.row].thumbnail)!)
            }
            cell.ComicLbl.text = myCharacterComicResult?[indexPath.row].title ?? "nil"
        }
        return cell;
      
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!noData){
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ComicDetailPage") as? ComicsDetailViewController else { return }
            vc.myComic = myCharacterComicResult?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.size.width/2)-3, height: (view.frame.size.height/2)-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 1, bottom: 1, right: 1)
    }
}



//MARK: UICOLLECTİONVİEWCELL
class MyCollectionCell:UICollectionViewCell{
    
    @IBOutlet weak var ComicImage: UIImageView!
    @IBOutlet weak var ComicLbl: UILabel!
    override func awakeFromNib() {
    }
    
}
