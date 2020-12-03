//
//  AHImagesBrower.swift
//  AHBrower
//
//  Created by 何培俊 on 2017/9/15.
//  Copyright © 2017年 jacky.he. All rights reserved.
//

import UIKit

class AHImagesBrower: UIView,UIScrollViewDelegate, AHZoomViewDelegaet {

    var oldFrame : CGRect?
    var scrollView : UIScrollView?
    var currentIndex = 0
    var imgs = [String]()
    var loadFinsh = false
    
    
    class func amShowImgs(imgeV:UIImageView,imgs:Array<String>,anIndex:Int){
        let imageBrower = AHImagesBrower.init(frame: CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h))
        imageBrower.beginShow(imgeV: imgeV, images: imgs, atIndex: anIndex)
        
    }
    
    func beginShow(imgeV:UIImageView,images:Array<String>,atIndex:Int)  {
        currentIndex = atIndex
        imgs = images
        guard imgeV.image != nil else {
            return
        }
        let oldImg = imgeV.image!
        let window = UIApplication.shared.keyWindow
        oldFrame = imgeV.convert(imgeV.bounds, to: window)
        backgroundColor = UIColor.black
        alpha = 0
        // 用于处理效果的imageView
        let tempImg = UIImageView.init(frame: oldFrame!)
        tempImg.image = oldImg
        addSubview(tempImg)
        window?.addSubview(self)
        
        //添加scrollView
        scrollView = UIScrollView.init(frame: UIScreen.main.bounds)
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.isHidden = true
        scrollView?.delegate = self;
        if imgs.count == 1 {
            currentIndex += 1
        }
        var imgIndex = currentIndex
        if currentIndex == 0 {
            imgIndex += 1
        }else if currentIndex == imgs.count-1 && imgs.count > 2{
            imgIndex -= 1
        }
        let first = getAmImageBrower(index: CGFloat(imgIndex - 1),tag: 0)
        first.changeImage(imageUrl: imgs[imgIndex-1])
        
        if imgs.count > 1 {
            let second = getAmImageBrower(index: CGFloat(imgIndex),tag: 1)
            second.changeImage(imageUrl: imgs[imgIndex])
        }
        if imgs.count > 2 {
            let third = getAmImageBrower(index: CGFloat(imgIndex + 1),tag: 2)
            third.changeImage(imageUrl: imgs[imgIndex+1])
        }
        
        addSubview(scrollView!)
        scrollView?.contentSize = CGSize.init(width: screen_w*CGFloat(images.count)+1, height: screen_h)
        scrollView?.setContentOffset(CGPoint.init(x: screen_w * CGFloat(atIndex), y: 0), animated: false)
        
        bringSubviewToFront(tempImg)
        let tempImg_w = tempImg.size.width
        let tempImg_h = tempImg.size.height
        let rs = tempImg_h/tempImg_w > screen_h/screen_w
        if rs {
            UIView.animate(withDuration: 0.3, animations: {
                tempImg.frame = CGRect.init(x: (screen_w - tempImg_w*screen_h/tempImg_h)/2, y: 0, width: tempImg_w*screen_h/tempImg_h, height: screen_h)
                self.alpha = 1
            }, completion: { (finsh) in
                tempImg.isHidden = true
                self.scrollView?.isHidden = false
                self.loadFinsh = true
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                tempImg.frame = CGRect.init(x: 0, y: (screen_h - tempImg_h*screen_w/tempImg_w)/2, width: screen_w, height: tempImg_h*screen_w/tempImg_w)
                self.alpha = 1
            }, completion: { (finsh) in
                tempImg.isHidden = true
                self.scrollView?.isHidden = false
                self.loadFinsh = true
            })
        }
    }
    
    //处理情况，如果是第一次，那么不处理
    func handleChangeImageIndex(toLeft:Bool) {
        guard !(currentIndex == 0 || (currentIndex == 1 && toLeft) || currentIndex == imgs.count-1 || (currentIndex == imgs.count-2 && !toLeft)) else {
            return
        }

        let first = self.viewWithTag(100) as! AHZoomView
        let second = self.viewWithTag(101) as! AHZoomView
        let third = self.viewWithTag(102) as! AHZoomView
        if toLeft {
            first.setLeft(left: third.right)
            first.changeImage(imageUrl: imgs[currentIndex+1])
            second.tag = 100
            third.tag = 101
            first.tag = 102
        }else{
            third.setRight(right: first.left)
            third.changeImage(imageUrl: imgs[currentIndex-1])
            third.tag = 100
            first.tag = 101
            second.tag = 102
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard loadFinsh else {
            return
        }
        
        let changeIndex = Int(scrollView.contentOffset.x/screen_w)
        
        if scrollView.contentOffset.x < screen_w*CGFloat(currentIndex) - screen_w*0.8 {
            if currentIndex != changeIndex {
                currentIndex = Int(scrollView.contentOffset.x/screen_w)
                handleChangeImageIndex(toLeft: false)
            }
        }else if scrollView.contentOffset.x > screen_w*CGFloat(currentIndex) + screen_w*0.8 {
            if currentIndex != changeIndex {
                currentIndex = Int(scrollView.contentOffset.x/screen_w)
                handleChangeImageIndex(toLeft: true)
            }
        }
        
        
    }
    // 处理获取imageBrower的方法
    func getAmImageBrower(index:CGFloat,tag:Int) -> AHZoomView{
        let brower = AHZoomView.init(frame: CGRect.init(x: screen_w * index, y: 0, width: screen_w, height: screen_h))
        brower.delegate = self
        brower.tag = 100+tag
        scrollView?.addSubview(brower)
        return brower
    }
    
//    AHZoomViewDelegaet
    func hide(view:AHZoomView) {
        let img = view.imageView
        UIView.animate(withDuration: 0.2, animations: {
            img!.frame = self.oldFrame!
        }) { (finsh) in
            self.removeFromSuperview()
        }
    }

}
