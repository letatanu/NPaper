//
//  rightViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 10/28/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Foundation
import Cocoa




class RightView: NSScrollView
{
    
    var viewsArray = [Paper]()
   
    var color : NSColor = NSColor.black
    
    
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
    
    public func displayWithViewsArray(viewarray: [Paper], with frame: NSRect)
    {
        self.documentView = NSView(frame: frame)
        viewsArray = [Paper]()
        for ele in viewarray
        {
            viewsArray.addPaper(at: frame, with: ele.img, on: self.documentView!)
        }
    }
    
    public func addNewPage(at frame: NSRect)
    {
        viewsArray.addStyle1(in: self.documentView!, with: frame)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}



