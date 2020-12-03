//
//  WaterImage.swift
//  picc
//
//  Created by 何培俊 on 2017/9/13.
//  Copyright © 2017年 上海劲牛信息技术有限公司. All rights reserved.
//

import UIKit

class WaterImage: NSObject {
    var imageW : CGFloat? = 0
    var imageH : CGFloat? = 0
    var imgStr : String?
    var imageUrl: URL?
    
    
    class func getImage(img:Dictionary<String, Any>) -> WaterImage {
        let waterImg = WaterImage.init()
        waterImg.imageW = img["w"] as? CGFloat
        waterImg.imageH = img["h"] as? CGFloat
        waterImg.imageUrl = URL.init(string: (img["img"] as? String)!)
        return waterImg
    }
    
    class func getImage(imgString:String) -> WaterImage? {
        let waterImg = WaterImage.init()
        let img = UIImage.init(contentsOfFile: imgString)
        if img == nil {
            return nil
        }
        waterImg.imageW = img?.size.width
        waterImg.imageH = img?.size.height
        waterImg.imgStr = imgString
        
        return waterImg
    }
    
}
