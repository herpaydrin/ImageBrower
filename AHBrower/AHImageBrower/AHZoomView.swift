//
//  AHZoomView.swift
//  AHBrower
//
//  Created by 何培俊 on 2017/9/15.
//  Copyright © 2017年 jacky.he. All rights reserved.
//

import UIKit
import SDWebImage
protocol AHZoomViewDelegaet {
    func hide(view:AHZoomView)
}

class AHZoomView: UIView,UIScrollViewDelegate {

    var delegate:AHZoomViewDelegaet?
    var scrollView : UIScrollView?
    var imageView : UIImageView?
    // 手动处理
    let isLocalImage = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        scrollView = UIScrollView.init(frame: UIScreen.main.bounds)
        scrollView?.contentMode = UIView.ContentMode.scaleToFill
        
        self.addSubview(scrollView!)
        
        imageView = UIImageView.init()
        imageView?.backgroundColor = UIColor.gray
        imageView?.isUserInteractionEnabled = true
        
        scrollView?.addSubview(imageView!)
        scrollView?.contentSize = (imageView?.frame.size)!
        // 图片放大最大最小张力
        scrollView?.minimumZoomScale = 1.0
        scrollView?.maximumZoomScale = 2.5
        scrollView?.delegate = self
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 跟换图片之后需要做的处理
    func changeImage(imageUrl:String) {
        
        if isLocalImage {
            // 本地图片
            let img = UIImage.init(contentsOfFile: imageUrl)
            imageView?.image = img
            let BBB = screen_w/screen_h
            let JJJ = (img?.size.width)!/(img?.size.height)!
            if BBB == JJJ {
                imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h)
            }else if BBB > JJJ {
                imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_h * JJJ, height: screen_h)
            }else{
                imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_w/JJJ)
            }
            imageView?.center = (scrollView?.center)!
        }else{
            
            imageView?.sd_setImage(with: URL.init(string: imageUrl), completed: { (bImage, error, SDImageCacheType, url) in
                guard bImage != nil else {
                    self.imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_w)
                    self.imageView?.center = (self.scrollView?.center)!
                    return
                }
                let BBB = screen_w/screen_h
                let JJJ = (bImage?.size.width)!/(bImage?.size.height)!
                if BBB == JJJ {
                    self.imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h)
                }else if BBB > JJJ {
                    self.imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_h * JJJ, height: screen_h)
                }else{
                    self.imageView?.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_w/JJJ)
                }
                self.imageView?.center = (self.scrollView?.center)!
            })
        }
        imageView?.isUserInteractionEnabled = true
//        添加双击事件
        let doubleClickTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleClickImageView(tap:)))
        doubleClickTap.numberOfTapsRequired = 2
        doubleClickTap.numberOfTouchesRequired = 1
        imageView?.addGestureRecognizer(doubleClickTap)
        
        let singleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideThisImage(tap:)))
        imageView?.addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleClickTap)
    }
    
//    双击查看大图
    @objc func doubleClickImageView(tap: UITapGestureRecognizer) {
        if (scrollView!.zoomScale > 1.0) {
            scrollView?.setZoomScale(1.0, animated: true)
        } else {
            scrollView?.setZoomScale(2.5, animated: true)
        }
    }
    
//    单击隐藏图片
    @objc func hideThisImage(tap:UITapGestureRecognizer) {
        scrollView?.setZoomScale(1.0, animated: false)
        self.delegate?.hide(view: self)
        
    }
    
    // 代理方法
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let originalSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        let offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width)/2 : 0
        let offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height)/2 : 0
        imageView?.center = CGPoint.init(x: contentSize.width/2 + offsetX, y: contentSize.height/2+offsetY)
        
    }

}
