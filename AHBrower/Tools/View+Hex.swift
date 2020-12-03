//
//  View+Hex.swift
//  MySW
//
//  Created by 何培俊 on 2016/5/15.
//  Copyright © 2016年 jacky.he. All rights reserved.
//

import Foundation
import UIKit

let screen_w = UIScreen.main.bounds.width
let screen_h = UIScreen.main.bounds.height

extension UIView {
    
    var left:CGFloat{
        return frame.origin.x
    }
    func setLeft(left:CGFloat){
        var aFrame = frame
        aFrame.origin.x = left
        frame = aFrame
    }
    
    var right:CGFloat{
        return frame.origin.x + frame.size.width
    }
    func setRight(right:CGFloat){
        var aFrame = frame
        aFrame.origin.x = right - frame.size.width
        frame = aFrame
    }
    
    var top:CGFloat{
        return frame.origin.y
    }
    func setTop(top:CGFloat){
        var aFrame = frame
        aFrame.origin.y = top
        frame = aFrame
    }
    
    var bottom:CGFloat{
        return frame.origin.y + frame.size.height
    }
    func setBottom(bottom:CGFloat){
        var aFrame = frame
        aFrame.origin.y = bottom - frame.size.height
        frame = aFrame
    }
    
    var width:CGFloat{
        return frame.size.width
    }
    
    func setWidth(width:CGFloat){
        var aFrame = frame
        aFrame.size.width = width
        frame = aFrame
    }
    
    var height:CGFloat{
        return frame.size.height
    }
    func setHeight(height:CGFloat){
        var aFrame = frame
        aFrame.size.height = height
        frame = aFrame
    }
    
    var origin:CGPoint{
        return frame.origin
    }
    func setOrigin(origin:CGPoint){
        var aFrame = frame
        aFrame.origin = origin
        frame = aFrame
    }
    
    var size:CGSize {
        return frame.size
    }
    func setSize(size:CGSize){
        var aFrame = frame
        aFrame.size = size
        frame = aFrame
    }
    
    
}
