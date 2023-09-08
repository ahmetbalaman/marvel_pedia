//
//  HeroItemsTableViewCell.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 14.07.2023.
//

import UIKit

class HeroItemsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var HeroItemLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
