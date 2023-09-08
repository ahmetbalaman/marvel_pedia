//
//  ComicTableViewCell.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 19.07.2023.
//

import UIKit

class ComicTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ComicImage: UIImageView!
    @IBOutlet weak var ComicLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
