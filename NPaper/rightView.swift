//
//  rightViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 10/28/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Foundation
import Cocoa




class RightView: NSScrollView, NSWindowDelegate
{
    
    
    var viewsArray = [Paper]()
   
    var color : NSColor = NSColor.black
    
    
    override func scrollWheel(with event: NSEvent) {
        let visibleRect = self.contentView.documentVisibleRect;
        NSLog("Visible rect:%s", NSStringFromRect(visibleRect));
       // let currentScrollPosition = visibleRect.origin;
    }
    
    //set new point for papers when nsscroll is scrolled
    
    public func changePathColor(to color: NSColor)
    {
        for ele in viewsArray
        {
            ele.color = color
        }
    }
    
    public func changePathSize(to size: CGFloat)
    {
        for ele in viewsArray
        {
            ele.lineWidth = size
        }
    }
    
    
}



