//
//  ComicsDetailViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 17.07.2023.
//

import UIKit

class ComicsDetailViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var ComicImageView: UIImageView!
    @IBOutlet weak var ComicNameLbl: UILabel!
    @IBOutlet weak var ComicDescription: UILabel!
    
    @IBOutlet weak var Segments: UISegmentedControl!
    @IBOutlet weak var myComicTableView: UITableView!
    
    @IBOutlet weak var ImageCollectionView: UIView!
    @IBOutlet weak var FavoriteBtn: UIButton!
    
    //MARK: - Veriables
    var whichPage = 0
    let defaults = UserDefaults.standard
    var chooseItemCount: Int?;
    var myComic:ComicResult?
    var url:String="";
    var whichOneChoosed:String?
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC=segue.destination as! CollectionViewController
//        destVC.myComicImages = sender as? [Thumbnail] ?? [Thumbnail(path: "clock", thumbnailExtension: "")]
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Segments.selectedSegmentIndex = -1
        initTable()
        initLocalFavoriteData()
       
        if(myComic == nil){
            print("my comic is nil")
            getComicData()
        }else{
            initData()
        }
        initCollection()
        whichPageCome()
        
    }
    
    
    // MARK: - IBActions

    @IBAction func SwipeLeftAction(_ sender: Any) {
        
        if(Segments.numberOfSegments > (whichPage+1)){
            Segments.selectedSegmentIndex =
            Segments.selectedSegmentIndex + 1
        }else{
            Segments.selectedSegmentIndex = 0
            print("you already reach the end of left")
        }
        WhichOneChoosed(sender)
    }
    
    
    @IBAction func SwipeRight(_ sender: Any) {
        if(whichPage > 0){
            Segments.selectedSegmentIndex =
            Segments.selectedSegmentIndex - 1
        }else{
            Segments.selectedSegmentIndex = 3
            print("you already reach the end of the right")
        }
        
        WhichOneChoosed(sender)
    }
    
    
    @IBAction func AddFavoritesAction(_ sender: Any) {
        let comicId = myComic?.id ?? 0
        let comicTitle = myComic?.title ?? ""
        let myData:[String:Int] = [comicTitle : comicId]
        
            
            if(MyLocalVeriables.allMyFavoriteComics.contains(where: {$0.key == myData.keys.first})){
                MyLocalVeriables.allMyFavoriteComics.removeValue(forKey: myComic?.title ?? "")
            }else{
                MyLocalVeriables.allMyFavoriteComics[comicTitle] = comicId
            }
        defaults.set(MyLocalVeriables.allMyFavoriteComics, forKey: "ComicsKey")
        if(MyLocalVeriables.allMyFavoriteComics.contains(where: {$0.key == myData.keys.first})){
            FavoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            tabBarController?.tabBar.items?[1].badgeValue = "New!"
        }else{
            FavoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    
    
    
    @IBAction func WhichOneChoosed(_ sender: Any) {
        
        switch Segments.selectedSegmentIndex{
        case 0:
            guard let availableComics = self.myComic?.characters?.returned else {
                print("it is")
                print(self.myComic?.characters?.returned ?? 0)

                return
            }
            chooseItemCount = availableComics
            whichPage = 0
            break
        case 1:
            guard let availableComics = self.myComic?.stories?.returned else {
                print(self.myComic?.stories?.returned ?? 0)

                return
            }
            chooseItemCount = availableComics
            whichPage = 1
            break
        case 2:
            guard let availableComics = self.myComic?.events?.returned else {
                print(self.myComic?.events?.returned ?? 0)
     return
            }
            chooseItemCount = availableComics
            whichPage = 2
            break
        case 3:
            
//            performSegue(withIdentifier: "ToImagesCollection", sender:self.myComic?.images)
            
            
            guard let availableComics = self.myComic?.images?.count else {
                print(self.myComic?.images?.count ?? 0)
                return
            }
            chooseItemCount = availableComics
            whichPage = 3
            break
            
            
        default:
            break
        }
        myComicTableView.reloadData()
        
        
    }
    
    //MARK: - Functions
    
    
    
    private func whichPageCome(){
        
        switch whichOneChoosed{
        case "Series":
            Segments.removeSegment(at: 3, animated: true)
            
            break
            
        case "Stories":
            Segments.removeSegment(at: 1, animated: true)
            Segments.removeSegment(at: 3, animated: true)
            break
            
        case "Events":
            
                Segments.removeSegment(at: 2, animated: true)
            
                Segments.removeSegment(at: 3, animated: true)
            break
            
        default:
            break
        }
        
    }
    
    //BURAYA İYİCE BAK
    private func initLocalFavoriteData(){
        let comicId = myComic?.id ?? 0
        let comicTitle = myComic?.title ?? ""
        let myData:[String:Int] = [comicTitle : comicId]
        if let allMyFavoriteComics = defaults.object(forKey: "ComicsKey") as? [String:Int]{
            if(allMyFavoriteComics.contains(where: {$0.key == myData.keys.first})){
                FavoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            print(allMyFavoriteComics)
        }
    }
    func getComicData() {
        NetworkManager.shared.makeURLRequest(baseUri: url) { comicResult in
            if comicResult?.thumbnail != nil{
                setTheImage(image: self.ComicImageView, myPhoto: (comicResult?.thumbnail)!)
            }
            self.ComicNameLbl.text = comicResult?.title
            self.ComicDescription.text = comicResult?.description
            self.myComic = comicResult
            self.initLocalFavoriteData()

        }
    }
    private func initTable() {
        myComicTableView.delegate = self
        myComicTableView.dataSource = self
     }
    private func initCollection() {
//        myComicTableView.frame = view.bounds
        myComicTableView.dataSource = self
        myComicTableView.delegate = self
    }
    private func initData() {
        
        if myComic?.thumbnail != nil{
            setTheImage(image: self.ComicImageView, myPhoto: (myComic?.thumbnail)!)
        }
        self.ComicNameLbl.text = myComic?.title
        self.ComicDescription.text = myComic?.description
    }
     
     
    
    

}

//MARK: - Extesions

extension ComicsDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chooseItemCount == 0 {
            return 1
        }
        return chooseItemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicIdentifierCell", for: indexPath) as! ComicTableViewCell
        
        if(chooseItemCount == 0){
            cell.ComicImage.image = UIImage(systemName: "nosign")
            cell.ComicImage.tintColor = .red
            cell.ComicLbl.text = "There is No data"
        }else{
            switch(whichPage) {
            case 0 :
//                ImageCollectionView.isHidden = true
            cell.ComicImage.image = nil
                cell.ComicLbl.text = myComic?.characters?.items?[indexPath.row].name
                break
            case 1:
//                ImageCollectionView.isHidden = true
                cell.ComicImage.image = nil
                cell.ComicLbl.text = myComic?.stories?.items?[indexPath.row].name
                break
            case 2:
//                ImageCollectionView.isHidden = true
                cell.ComicImage.image = nil
                cell.ComicLbl.text = myComic?.events?.items?[indexPath.row].name
                break
            case 3:
//                ImageCollectionView.isHidden = false
                cell.ComicLbl.text = nil
                if let data = myComic?.images?[indexPath.row]  {
                    if myComic?.images != nil {
                        setTheImage(image: cell.ComicImage  , myPhoto:data )}
                }
                break
            default:
                cell.ComicImage.image = nil
               
                cell.ComicLbl.text = myComic?.title
            }
        }
        return cell
    }
    
    
}


//
//class UICollectionCell: UICollectionViewCell {
//    @IBOutlet weak var myImage: UIImageView!
//}
//
//class CollectionViewController:UIViewController{
//    var chooseItemCount = 3;
//    var myComicImages:[Thumbnail]?;
//    @IBOutlet weak var ComicImagesCollectionView: UICollectionView!
//    
//   
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        ComicImagesCollectionView.delegate = self
//        ComicImagesCollectionView.dataSource = self
//        
//    }
//    
//}
//
//
//
//extension CollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if(myComicImages?.count == 0 ){
//            return 1
//        }
//        return myComicImages?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myComicCollectionCell", for: indexPath) as! UICollectionCell
//
//        if let data = myComicImages?[indexPath.row]  {
//            if myComicImages != nil {
//                setTheImage(image: cell.myImage  , myPhoto:data )}
//        }
//        return cell
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: (view.frame.size.width/2)-3, height: (view.frame.size.height/2)-3)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        1
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 1, bottom: 1, right: 1)
//    }
//    
//
//
//
//
//}
//
//
