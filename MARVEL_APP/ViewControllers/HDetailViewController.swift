//
//  HeroesDetailPageViewController.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 13.07.2023.
//

import UIKit
import ShimmerSwift


class HeroesDetailPageViewController: UIViewController {
    //MARK: Outlets

    @IBOutlet weak var HeroSegments: UISegmentedControl!
    @IBOutlet weak var myHeroDescLbl: UILabel!
    @IBOutlet weak var myHeroNameLbl: UILabel!
    @IBOutlet weak var myHeroImage: UIImageView!
    @IBOutlet weak var ItemsTable: UITableView!
    @IBOutlet weak var FavoritesButton: UIButton!

    //MARK: - Variables
    let defaults = UserDefaults.standard
    var whichPage = 0
    var hero: CharactersResult?;
    var chooseItemCount: Int?;
    var whichOneChoosed: String?;

    var shimmerView = ShimmeringView(
    )

    @IBOutlet weak var TopViewer: UIView!
    override func viewDidLoad() {

        myHeroImage.addDownToUpGradient()



        super.viewDidLoad()
        HeroSegments.selectedSegmentIndex = -1

        initShimmer()
        initLocal() // init favorites
        initData()
        initTable()

    }

    //MARK: - Actions


    @IBAction func AddFavoritesAction(_ sender: Any) {

        let heroId = hero?.id ?? 0
        let heroTitle = hero?.name ?? ""

        let myData: [String: Int] = [heroTitle: heroId]

        if (hero?.name) != nil {
            if(MyLocalVeriables.allMyFavoriteHeroes.contains(where: { $0.key == myData.keys.first })) {
                MyLocalVeriables.allMyFavoriteHeroes.removeValue(forKey: hero?.name ?? "")
                shimmerView.isShimmering = false
            } else {
                shimmerView.isShimmering = true

                MyLocalVeriables.allMyFavoriteHeroes[heroTitle] = heroId
            }
        }
        defaults.set(MyLocalVeriables.allMyFavoriteHeroes, forKey: "HeroesKey")
        if MyLocalVeriables.allMyFavoriteHeroes.contains(where: { $0.key == myData.keys.first }) {
            FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            shimmerView.isShimmering = true

            tabBarController?.tabBar.items?[1].badgeValue = "New!"

        } else {
            shimmerView.isShimmering = false
            FavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)

        }
    }

    @IBAction func SwipeLeftAction(_ sender: Any) {
        if(HeroSegments.numberOfSegments > (whichPage + 1)) {
            HeroSegments.selectedSegmentIndex =
                HeroSegments.selectedSegmentIndex + 1
        } else {
            HeroSegments.selectedSegmentIndex = 0
            print("you already reach the end of left")
        }
        WhichOneChoosed(sender)
    }



    @IBAction func WhichOneChoosed(_ sender: Any) {

        switch HeroSegments.selectedSegmentIndex {
        case 0:
            whichOneChoosed = "Comics"

            guard let availableComics = self.hero?.comics?.returned else {
                return
            }
            chooseItemCount = availableComics
            ItemsTable.reloadData()
            whichPage = 0
            break

        case 1:
            guard let availableComics = self.hero?.series?.returned else {
                return
            }


            chooseItemCount = availableComics

            ItemsTable.reloadData()
            whichPage = 1
            break

        case 2:

            guard let availableComics = self.hero?.stories?.returned else {
                return
            }


            chooseItemCount = availableComics

            ItemsTable.reloadData()
            whichPage = 2

            break

        case 3:
            guard let availableComics = self.hero?.events?.returned else {
                return
            }


            chooseItemCount = availableComics

            ItemsTable.reloadData()
            whichPage = 3

            break

        default:

            break


        }

    }
    // MARK: - Functions
    private func initShimmer() {
        self.view.addSubview(shimmerView)

        shimmerView.tintColor = .systemYellow
        shimmerView.backgroundColor = .systemYellow

        shimmerView.frame = CGRect(
            x: 0, y: 0, width: TopViewer.frame.width, height: TopViewer.frame.height)


        shimmerView.shimmerSpeed = 250

        shimmerView.shimmerDirection = .down
        shimmerView.contentView = TopViewer
    }
    private func initLocal() {
        let heroId = hero?.id ?? 0
        let heroTitle = hero?.name ?? ""

        let myData: [String: Int] = [heroTitle: heroId]

        if let allMyFavoriteHeroes = defaults.object(forKey: "HeroesKey") as? [String: Int] {
            print(allMyFavoriteHeroes)
            if allMyFavoriteHeroes.contains(where: { $0.key == myData.keys.first }) {
                shimmerView.reloadInputViews()
                shimmerView.isShimmering = true
                FavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            print(allMyFavoriteHeroes)
        }
    }
    private func initTable() {
        ItemsTable.delegate = self
        ItemsTable.dataSource = self
    }
    private func initData() {
        if(hero != nil) {
            myHeroNameLbl.text = hero?.name
            myHeroDescLbl.text = hero?.description
            if hero?.thumbnail != nil {
                setTheImage(image: myHeroImage, myPhoto: (hero?.thumbnail)!)
            }

        }
    }


}



extension HeroesDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chooseItemCount == 0 {
            return 1
        }
        return chooseItemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! HeroItemsTableViewCell
        if chooseItemCount == 0 {
            cell.HeroItemLbl.text = "There is no data"
        } else {
            switch(whichPage) {
            case 0:
                cell.HeroItemLbl.text = hero?.comics?.items?[indexPath.row].name
                break
            case 1:
                cell.HeroItemLbl.text = hero?.series?.items?[indexPath.row].name
                break
            case 2:
                cell.HeroItemLbl.text = hero?.stories?.items?[indexPath.row].name

                break
            case 3:
                cell.HeroItemLbl.text = hero?.events?.items?[indexPath.row].name
                break
            default:
                cell.HeroItemLbl.text = hero?.name
            }
        }

        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ComicDetailPage") as? ComicsDetailViewController else {

            return
        }

        if(chooseItemCount == 0) {

        } else {
            switch(whichPage) {
            case 0:
                vc.url = self.hero?.comics?.items?[indexPath.row].resourceURI ?? "0"
                print(self.hero?.comics?.items?[indexPath.row].resourceURI ?? "0")
                self.navigationController?.pushViewController(vc, animated: true)

                break

            case 1:

                vc.whichOneChoosed = "Series"

                vc.url = self.hero?.series?.items?[indexPath.row].resourceURI ?? "0"
                print(self.hero?.series?.items?[indexPath.row].resourceURI ?? "0")
                self.navigationController?.pushViewController(vc, animated: true)
                break

            case 2:


                vc.whichOneChoosed = "Stories"

                vc.url = self.hero?.stories?.items?[indexPath.row].resourceURI ?? "0"
                print(self.hero?.stories?.items?[indexPath.row].resourceURI ?? "0")
                self.navigationController?.pushViewController(vc, animated: true)
                break

            case 3:
                vc.whichOneChoosed = "Events"
                vc.url = self.hero?.events?.items?[indexPath.row].resourceURI ?? "0"
                print(self.hero?.events?.items?[indexPath.row].resourceURI ?? "0")
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                vc.url = self.hero?.comics?.items?[indexPath.row].resourceURI ?? "0"
                print(self.hero?.comics?.items?[indexPath.row].resourceURI ?? "0")
                self.navigationController?.pushViewController(vc, animated: true)
                break



            }

        }

    }




}



