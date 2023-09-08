//
//  MyHeroesTableViewCell.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 13.07.2023.
//

import UIKit


class MyHeroesTableViewCell: UITableViewCell {
    
    
    
//    MARK - Properties
    
    
    
    @IBOutlet weak var heroThumbnailImage: UIImageView!
    
    @IBOutlet weak var chacterNameLbl: UILabel!
    //    MARK - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        heroThumbnailImage.addDownToUpGradient()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        
        // Configure the view for the selected state
    }

}
