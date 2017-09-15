//
//  WaterfallCollectionVC.swift
//  picc
//
//  Created by 何培俊 on 2017/9/13.
//  Copyright © 2017年 上海劲牛信息技术有限公司. All rights reserved.
//

import UIKit

private let reuseIdentifier = "WaterfallCellId"

class WaterfallCollectionVC: UIViewController,WaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionView : UICollectionView? = nil
    var images = [WaterImage]()
    var imageUrl = [String]()
    
    
    
    /* 切换本地和网络请求的图片   */
    let isLocalImg = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "图片"
        view.backgroundColor = UIColor.yellow
        
        
        
        if isLocalImg {
            // 图片的位置 目前是在 document
            var localPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let paths = FileManager.default.subpaths(atPath: localPath!)!
            guard paths.count > 1 else {
                return
            }
            localPath?.append("/img")
            let newImages =  FileManager.default.subpaths(atPath: localPath!)!
            for index in 0 ..< newImages.count {
                if index == 0 {
                    continue
                }
                let waterImg = WaterImage.getImage(imgString: localPath!+"/"+newImages[index])
                imageUrl.append(localPath!+"/"+newImages[index])
                images.append(waterImg)
            }
        }else{
            let path = Bundle.main.path(forResource: "1.plist", ofType: nil)
            let imageDics = NSArray.init(contentsOfFile: path!)!
            for index in 0 ..< imageDics.count {
                let tempDic = imageDics[index] as! Dictionary<String, Any>
                let waterImage = WaterImage.getImage(img: tempDic)
                imageUrl.append((tempDic["img"] as? String)!)
                images.append(waterImage)
            }
        }
        
        
        let waterfallLayout = WaterfallLayout.init(columnC: 3)
        waterfallLayout.setColumnCount(columnS: 5, rowS: 5, sectionIns: UIEdgeInsetsMake(5, 5, 5, 5))
        waterfallLayout.delegate = self
        
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: waterfallLayout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib.init(nibName: "WaterfallCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        
    }
    //根据item的宽度与indexPath计算每一个item的高度
    func waterfallLayout(waterfallLayout: WaterfallLayout, itemWidth: CGFloat, indexPath: IndexPath) -> Int {
        //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
        let waterImg = images[indexPath.row]
        return Int(waterImg.imageH! / waterImg.imageW! * itemWidth)
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WaterfallCell
        
        
        if isLocalImg {
            let waterImg = images[indexPath.row]
            cell.setImageName(imgString: waterImg.imgStr!)
        }else{
            cell.setImageUrl(url: images[indexPath.row].imageUrl!)
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WaterfallCell
        
        if isLocalImg {
            AHImagesBrower.amShowImgs(imgeV: cell.imgView, imgs: imageUrl, anIndex: indexPath.row)
        }else{
            AHImagesBrower.amShowImgs(imgeV: cell.imgView, imgs: imageUrl, anIndex: indexPath.row)
        }
    }

}
