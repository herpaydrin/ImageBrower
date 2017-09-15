//
//  WaterfallCell.swift
//  picc
//
//  Created by 何培俊 on 2017/9/13.
//  Copyright © 2017年 上海劲牛信息技术有限公司. All rights reserved.
//

import UIKit
import SDWebImage

class WaterfallCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var imgUrl:URL?
    
    func setImageUrl(url:URL) {
        imgUrl = url
        imgView.sd_setImage(with: url, completed: nil)
        
    }
    
    func setImageName(imgString:String) {
        imgView.image = UIImage.init(contentsOfFile: imgString)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
