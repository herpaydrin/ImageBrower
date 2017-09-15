//
//  WaterfallLayout.swift
//  picc
//
//  Created by 何培俊 on 2017/9/12.
//  Copyright © 2017年 上海劲牛信息技术有限公司. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDelegate : NSObjectProtocol{
    
    func waterfallLayout(waterfallLayout:WaterfallLayout,itemWidth:CGFloat,indexPath:IndexPath) -> Int
    
}

class WaterfallLayout: UICollectionViewLayout {
    
    var delegate:WaterfallLayoutDelegate?
    var columnCount = 2
    var columnSpace = 0
    var rowSpace = 0
    var sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    // 用来记录每列最大值
    var maxDic = Dictionary<Int, Int>()
    // 保存每一个item的attributes
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    init(columnC:NSInteger) {
        super.init()
       columnCount = columnC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColumnCount(columnS:NSInteger,rowS:NSInteger,sectionIns:UIEdgeInsets) {
        columnSpace = columnS
        rowSpace = rowS
        sectionInset = sectionIns
    }
    override func prepare() {
        super.prepare()
        //初始化字典，有几列就有几个键值对，key为列，value为列的最大y值，初始值为上内边距
        for index in 0 ..< columnCount {
            maxDic.updateValue(Int(sectionInset.top), forKey: index)
        }
        //根据collectionView获取总共有多少个item
        let itemCount = collectionView?.numberOfItems(inSection: 0)
        if attributesArray.count > 0 {
            attributesArray.removeAll()
        }

        //为每一个item创建一个attributes并存入数组
        for index in 0 ..< itemCount! {
            let attributes = layoutAttributesForItem(at: IndexPath.init(row: index, section: 0))
            attributesArray.append(attributes!)

        }
        
    }
    //计算collectionView的contentSize
    override var collectionViewContentSize: CGSize{
        var maxNumber = 0
        //遍历字典，找出最长的那一列
        for index in 0 ..< maxDic.count {
            let value = maxDic[index]!
            
            if maxNumber < value {
                maxNumber = value
            }
        }
        //collectionView的contentSize.height就等于最长列的最大y值+下内边距
        return CGSize.init(width: 0, height: CGFloat(maxNumber) + sectionInset.bottom)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //根据indexPath获取item的attributes
        let att = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        //获取collectionView的宽度
        let  view_w = collectionView?.width
        
        
        //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
        let item_w = (Int(view_w! - sectionInset.left - sectionInset.right) - (columnCount - 1) * columnSpace) / columnCount
        
        var itemHeight = 0
        //获取item的高度，由外界计算得到
        if delegate != nil {
            itemHeight = (delegate?.waterfallLayout(waterfallLayout: self, itemWidth: CGFloat(item_w), indexPath: indexPath))!
        }
        
        //找出最短的那一列
        var minIndex = 0
        var minValue = maxDic[0]
        
        for index in 0..<maxDic.count {
            let value = maxDic[index]
            if minValue! > value! {
                minValue = value!
                minIndex = index
            }
        }
        //根据最短列的列数计算item的x值
        let itemX = Int(sectionInset.left) + (columnSpace + item_w) * minIndex
        
        //item的y值 = 最短列的最大y值 + 行间距
        let itemY = maxDic[minIndex]! + rowSpace
        
        //设置attributes的frame
        att.frame = CGRect.init(x: itemX, y: itemY, width: item_w, height: itemHeight)
        
        //更新字典中的最大y值
//        maxDic[minIndex] = itemY + itemHeight
        maxDic.updateValue(itemY + itemHeight, forKey: minIndex)
        return att
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
}
