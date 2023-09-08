//
//  ImageLoadService.swift
//  MARVEL_APP
//
//  Created by Ahmet Balaman on 13.07.2023.
//

import UIKit

func setTheImage( image myImage:UIImageView,myPhoto:Thumbnail){
    if(myPhoto.thumbnailExtension == "jpg"){
        let url = URL(string:"\(myPhoto.path!).jpg")
        myImage.kf.setImage(with: url)
    }else{
        let url = URL(string:"\(myPhoto.path!).gif")
        myImage.kf.setImage(with: url)
    }
}
