//
//  HeroesViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 13.07.2023.
//

import UIKit
import Kingfisher
import Moya


class HeroesViewController: UIViewController {
    
    //MARK: - Veriables
    var dipteMi:Bool                         = true; // en aşağı gelip gelmediğini kontrol ediyor.
    var aramaIkonBasildi: Bool               = true // arama ikonuna basıldı kontrölü
    var aramaTusuBasildi: Bool               = false // arama tuşuna basıldı kontrolü
    var comicAramaTusuBasildi: Bool          = false // çizgi roman tuşuna basıldı kontrolü
    var offset:Int                           = 30 //kaçlı bir şekikde gösterilmek istersen öyle gösterir
    var Heroes: [CharactersResult]?          = []  // kahramanların gösterildiği liste
    var mySearchHeroes: [CharactersResult]?  = [] // aranan kahramanların gösterildiği liste
    var mySearchComics: [ComicResult]?       = [] // aranan çizgiromanların gösterildiği liste
    var myChoosedHeroes: [CharactersResult]? = [] // seçilen kahramanları tutan liste
    var whichGroupByChoosed = "name"
    //MARK: - Outlets
    @IBOutlet weak var OrderByButton:           UIButton!
    @IBOutlet weak var BottomChoosedHeroesText: UILabel!
    @IBOutlet weak var BottomViewBar:           UIView!
    @IBOutlet weak var TopViewBar:              UIView!
    @IBOutlet weak var MarvelImage:             UIImageView!
    @IBOutlet var CharactersTable:              UITableView!
    @IBOutlet weak var SearchTextField:         UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBarItems()
        initTable()
        getHeroes(myParams: HeroRequestParams())
        initBottomBar()
    }
    
    //MARK: - IBActions
    @IBAction func bottomBarCancel(_ sender: Any) {
        myChoosedHeroes = []
        animateMovementDown()
        BottomChoosedHeroesText.text = ""
    }
    
    @IBAction func bottomSearchComics(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ComicSearchCharacter") as? ComicCharacterSearchViewController else {
            return
        }
        vc.myCharacterResult = myChoosedHeroes
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension
extension HeroesViewController:  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK: - Functions
    private func initTable() {
        TopViewBar.isHidden = self.aramaIkonBasildi
        SearchTextField.isHidden      = self.aramaIkonBasildi
        SearchTextField.delegate      = self
        SearchTextField.returnKeyType = .search
        CharactersTable.delegate      = self
        CharactersTable.dataSource    = self
        self.navigationItem.largeTitleDisplayMode = .never
        
    }
    private func initBottomBar(){
        BottomViewBar.isHidden = true
        BottomChoosedHeroesText.text = ""
    }
    
    private func initNavigationBarItems(){
        navigationController?.navigationBar.tintColor = .red
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"book.closed.fill"), style: .plain, target: self, action: #selector(didTapSearchComicIcon))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchIkon))
        
    }
    
    private func setPopUpMenuComicItems(){
        let myOwnClosureComic =  { (myEnum:ComicOrderByItems) in
            self.offset = 10
            print(myEnum.whichOne)
            if(self.comicAramaTusuBasildi){
               
                
                self.getSearchComics(
                    params:ComicSearchStartsWithParams(titleStartsWith: self.SearchTextField.text ?? "",orderBy: myEnum.whichOne))
                    
                self.mySearchComics = []
            }
        }
        self.OrderByButton?.menu = UIMenu(children: ComicPopUpMenuItems.map{item in

            UIAction(
                title: item.key.rawValue,
                image: UIImage(systemName: item.value),
                state: .off,
                handler: { _ in myOwnClosureComic(item.key) }
            )
            
        }
        )
        OrderByButton.showsMenuAsPrimaryAction = true
        OrderByButton.changesSelectionAsPrimaryAction = true
    }
    
    private func setPopUpMenuHeroItems(){
        let myOwnClosure =  { (myEnum:HeroOrderByItems) in
            print(myEnum.whichOne)
            if(!self.comicAramaTusuBasildi){
                self.whichGroupByChoosed = myEnum.whichOne;
                if(self.SearchTextField.text?.isEmpty ?? false){
                  
                    self.getHeroes(myParams: HeroRequestParams(orderBy: myEnum.whichOne))
                }else{
                    
                    self.getHeroes(
                        
                        myParams: HeroRequestParams(
                            nameStartsWith: self.SearchTextField.text ?? "",
                            orderBy: myEnum.whichOne,
                            doesHaveName: true
                        )
                 )
                        
                        
                }
                self.Heroes = []
                self.mySearchHeroes = []
            }
        }
      
        self.OrderByButton?.menu = UIMenu(children:  myPopUpHeroItems.map({ item in
            UIAction(
                title: item.key.rawValue,
                image: UIImage(systemName: item.value),
                state: .off,
                handler: { _ in myOwnClosure(item.key) }
            )
            
        }))
        OrderByButton.showsMenuAsPrimaryAction = true
        OrderByButton.changesSelectionAsPrimaryAction = true
        
    }
    @objc private func didTapSearchComicIcon() {
        print("şu an comictesin canım")
        
        
        SearchTextField.placeholder = "Search Comics!"
        aramaIkonBasildi ?  (comicAramaTusuBasildi = true) : (comicAramaTusuBasildi = false)
        if(comicAramaTusuBasildi){
            setPopUpMenuComicItems()
        }else{
            setPopUpMenuHeroItems()
        }
        print("comic arama tusu is \(comicAramaTusuBasildi)")
        showSearchBar()
        
        CharactersTable.reloadData()
    }
    @objc private func didTapSearchIkon() {
        setPopUpMenuHeroItems()
        SearchTextField.placeholder = "Search Characters!"
        if(comicAramaTusuBasildi){
            comicAramaTusuBasildi = false
            aramaIkonBasildi = true
        }
        showSearchBar()
        CharactersTable.reloadData()
        
    }
    
    private func showSearchBar(){
        aramaIkonBasildi = !aramaIkonBasildi
        MarvelImage.isHidden = !aramaIkonBasildi
        TopViewBar.isHidden = aramaIkonBasildi
        SearchTextField.isHidden = aramaIkonBasildi
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comicAramaTusuBasildi
        ? (mySearchComics?.count ?? 0)
        : (!aramaTusuBasildi 
           ? (Heroes?.count ?? 0)
           : (mySearchHeroes?.count ?? 0)
        )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataIdentifier", for: indexPath) as! MyHeroesTableViewCell
        //MARK: - Metin ile bak
        if(comicAramaTusuBasildi){
          
                if let data:ComicResult =  mySearchComics?[indexPath.row]{
                    
                    cell.chacterNameLbl.text = data.title
                    if data.thumbnail != nil {
                        setTheImage(image: cell.heroThumbnailImage, myPhoto: data.thumbnail!)}
                }else{
                    
                }
           
          
        }else{
            let data:CharactersResult = !aramaTusuBasildi ? Heroes![indexPath.row] : mySearchHeroes![indexPath.row]
            cell.chacterNameLbl.text = data.name
            if data.thumbnail != nil {
                setTheImage(image: cell.heroThumbnailImage, myPhoto: data.thumbnail!)}
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(comicAramaTusuBasildi){
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ComicDetailPage") as? ComicsDetailViewController else {
                return
            }
            vc.myComic = mySearchComics?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "HeroDetailPage") as? HeroesDetailPageViewController else {
                return
            }
            vc.hero = !aramaTusuBasildi ? Heroes?[indexPath.row] : mySearchHeroes?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .destructive, title: "Add To Comic Search"){
                    [weak self] (action, view, completionHandler) in
                    if((self?.comicAramaTusuBasildi) ?? false){
                        self?.showToast(message: "You can't add Comics!", font: .systemFont(ofSize: 10))
                        return
                    }else{
                        if(self?.aramaTusuBasildi ?? false){
                            if let myHero = self?.mySearchHeroes?[indexPath.row]{
                                self?.addSearchComic(hero: myHero)
                            }
                        }else{
                            if let myHero = self?.Heroes?[indexPath.row]{
                                self?.addSearchComic(hero: myHero)
                            }
                        }
                    }
                    completionHandler(true)
                },
            ])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeButton = UIContextualAction(style: .destructive, title: "Remove"){
            [weak self] (action, view, completionHandler) in
            if let myHero = self?.Heroes?[indexPath.row]{
                self?.removeSearchComic(hero: myHero)
            }
            completionHandler(true)
            
        }
        removeButton.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [
            removeButton
            
        ])
        
        
        
        
        
    }
    private func removeSearchComic(hero:CharactersResult){
        if(comicAramaTusuBasildi){
            self.showToast(message: "You can't remove Comics!", font: .systemFont(ofSize: 10))
            return
        }
        
        if self.myChoosedHeroes!.contains(where: { $0.name == hero.name }) {
            var dizi:[String] = []
            myChoosedHeroes?.removeAll(where: { $0.name == hero.name
            })
            
            myChoosedHeroes?.forEach({ CharactersResult in
                dizi.append(CharactersResult.name ?? "")
            })
            //metin ile buraya da bak
            BottomChoosedHeroesText.text = "\(dizi)"
            myChoosedHeroes!.isEmpty ? (animateMovementDown()) : (BottomViewBar.isHidden = false)
            
            
        } else {
            
            self.showToast(message: "You didn't add this hero!", font: .systemFont(ofSize: 15))
            
        }
        
        
        
        
    }
    
    func animateMovementUp(){
        BottomViewBar.frame = CGRect(
            x: view.safeAreaInsets.left,
            y: view.bounds.height + 75,
            width: view.bounds.inset(by: view.safeAreaInsets).width,
            height: 150)
        BottomViewBar.isHidden = false
        BottomViewBar.center = CGPoint(x:(view.bounds.size.width/2),
                                       y:(view.bounds.size.height))
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let self else { return }
            
            BottomViewBar.center = CGPoint(x:view.bounds.size.width/2,y:view.bounds.size.height-150)
            
            
        }
    }
    func animateMovementDown(){
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            BottomViewBar.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height+150)
            
        } completion: { _ in
            self.BottomViewBar.isHidden = true
        }
    }
    
    private func addSearchComic(hero:CharactersResult){
        
        
        //metin ile buraya bak
        
        if(comicAramaTusuBasildi){
            self.showToast(message: "You can only add heroes!", font: .systemFont(ofSize: 10))
            return
        }
        if(myChoosedHeroes!.count > 6){
            self.showToast(message: "Maximum Character is added", font: .systemFont(ofSize: 10))
        }
        //ELSE Kısmını yap
        
        
        
        if self.myChoosedHeroes!.contains(where: {
            $0.name == hero.name }) {
            self.showToast(message: "You already added this hero!", font: .systemFont(ofSize: 10))
        } else {
            var dizi:[String] = []
            if(myChoosedHeroes!.isEmpty){
                
                self.animateMovementUp()
            }
            myChoosedHeroes?.append(hero)
            myChoosedHeroes?.forEach({ CharactersResult in
                dizi.append(CharactersResult.name ?? "")
            })
            
            BottomChoosedHeroesText.text = "\(dizi)"
            
        }
        
        
        
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        
        if offsetY > (contentHeight - tableViewHeight) {
            
            if(self.dipteMi){
                self.offset = self.offset + 10
                
                if(comicAramaTusuBasildi){
                    if(self.whichGroupByChoosed == "name"){
                        self.whichGroupByChoosed = "title"
                    }
                    getSearchComics(
                        params:   ComicSearchStartsWithParams(titleStartsWith: SearchTextField.text ?? "",orderBy: self.whichGroupByChoosed,limit: 10,offset: offset)
                        )
                }else{

                    if(self.SearchTextField.text?.isEmpty ?? false){
                  
                        self.getHeroes(myParams: HeroRequestParams(orderBy:whichGroupByChoosed,limit: 10, offset: offset))
                    }else{
                        
                        self.getHeroes(myParams: HeroRequestParams(nameStartsWith: self.SearchTextField.text ?? "",orderBy: whichGroupByChoosed,limit: 10,offset: offset,doesHaveName: true))
                    }
                 
                 
                }
                
               
                
              
                
             
                
                
                //MARK: özel olarak search içinde oluştur
                print("en aşağı inildi ")
                dipteMi = false
            }
        }
        if(offsetY < (contentHeight - tableViewHeight)){
            dipteMi = true
        }
    }
    
//nameStartsWith:String = "none",orderBy:String="name",limit:Int = 30,offset:Int = 0
    func getHeroes(myParams:HeroRequestParams,doesHaveName:Bool = false) {
        
        
        NetworkManager.shared.makeAllHeroRequest(params:myParams,doesHaveName:doesHaveName){ kahraman in
            switch kahraman {
            case .success(let json):
                
                json?.data?.results?.forEach({ Result in
                    !self.aramaTusuBasildi ? self.Heroes?.append(Result) :  self.mySearchHeroes?.append(Result)
                })
                self.CharactersTable.reloadData()
                if(self.dipteMi){
                    self.animateFirstCellOnLoad()
                }
//                self.dipteMi = false
                
                
                break
                
                
                
            case .failure(let error):
                print("Error inside get  heroes: \(error)")
                break
                
            }}
    }
    
    func getSearchCharacters(myParams:HeroSearchStartsWithParams, offset: Int = 0){
        NetworkManager.shared.makeCharacterSearchRequest(params:myParams,completion: { resultState in
            switch resultState{
            case .success(let kahraman):
                kahraman?.data?.results?.forEach({ Result in
                    self.mySearchHeroes?.append(Result)
                })
                
                self.CharactersTable.reloadData()
                self.dipteMi = true
                //if(self.CharactersTable != nil){ }
                break
                
            case .failure(let Error):
                print("Get Search Chacters Error : \(Error)")
                break
            }
            
            
            
            
        })
        
        
    }
    
    func getSearchComics(params:ComicSearchStartsWithParams) {
        
        
        NetworkManager.shared.makeComicSearchRequest(params: params) { myResults in
            
            
            switch myResults{
            case .success(let allComics):
                allComics?.data?.results?.forEach({ ComicResult in
                    
                    self.mySearchComics?.append(ComicResult)
                })
                
                
                self.CharactersTable.reloadData()
                self.dipteMi = true
                break
                
            case .failure(let error):
                print("Get Search Comics error : \(error)")
                
                break
            }
            
            
            
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text!.count < 3){
            showToast(message: "Lütfen en az 3 harf girin", font: .systemFont(ofSize: 10))
            return false
        }else{
            mySearchHeroes = []
            mySearchComics = []
            self.aramaTusuBasildi = true
            textField.resignFirstResponder()
            if let text = textField.text {
                
                if(comicAramaTusuBasildi){
                    print("its in return state")
                    getSearchComics(params:ComicSearchStartsWithParams(titleStartsWith: text))
                }else{
                    getSearchCharacters(myParams: HeroSearchStartsWithParams(nameStartsWith: text))
                }
            }
            return true
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        mySearchHeroes = []
        mySearchComics = []
        self.aramaTusuBasildi = false
        self.CharactersTable.reloadData()
        return true
    }
    func animateFirstCellOnLoad() {
        print("Animasyon çağırıldı")
        if let firstCell = CharactersTable.cellForRow(at: IndexPath(row: 0, section: 0)) {
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                firstCell.transform = CGAffineTransform(translationX: -self.CharactersTable.bounds.width/5, y: 0)
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    firstCell.transform = CGAffineTransform.identity
                }, completion:  { _ in
                    UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                        firstCell.transform = CGAffineTransform(translationX: +self.CharactersTable.bounds.width/5, y: 0)
                        
                    }, completion:  { _ in
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                            firstCell.transform = CGAffineTransform.identity
                            
                        }, completion: nil)
                    })
                })
            })
        }
    }
}


