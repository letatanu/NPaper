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


//// The array of paper views
extension Array where Element: Paper
{
    mutating func add() -> Bool
    {
        let newPaper = Paper()
        self.append(newPaper as! Element)
        return true
    }
    
    mutating func add(frame: NSRect) -> Bool
    {
        //
        let newPaper = Paper()
        newPaper.frame = frame
        self.append(newPaper as! Element)
        return true
    }
    mutating func addStyle1(in View: NSView, with rect: NSRect) -> Bool
    {
        let verticalBound: CGFloat = 0
        let horizontalBound: CGFloat = 2
        let newPaper = Paper()
        newPaper.backgroundColor = NSColor.white
        if (self.count == 0)
        {
            let frame = rect
            newPaper.frame = NSRect(x: frame.origin.x + verticalBound, y: frame.origin.y + horizontalBound, width: frame.size.width - 2*verticalBound, height: frame.size.height - horizontalBound)
        }
        else
        {
            if let frame = self.last?.frame
            {
                let frame_ = View.frame
                View.frame = NSMakeRect(frame_.origin.x, frame_.origin.y, frame_.size.width, frame_.size.height + frame.size.height + 2*horizontalBound)
                newPaper.frame = NSRect(x: frame.origin.x, y: frame.origin.y + frame.size.height + horizontalBound, width: frame.size.width, height: frame.size.height)
                
            }
            else {
                return false
            }
        }
        View.addSubview(newPaper)
        self.append(newPaper as! Element)
        return true
    }
    /*
    mutating func resizeAllPapers(to frameSize: NSSize)
    {
        let verticalBound: CGFloat = 0
        let horizontalBound: CGFloat = 2

        let size = self.count
        for i in 0...size
        {
            let curView = self[i]
            if i == 0
            {
                curView.frame = NSRect(x: frameSize.origin.x + verticalBound, y: frameSize.origin.y + horizontalBound, width: frameSize.size.width - 2*verticalBound, height: frameSize.size.height - horizontalBound)
            }
            else {
                let preView = self[i-1]
            }
        }
    }*/
    
    mutating func addStyle2(in View: NSView) -> Bool
    {
        if let view_: NSView = View
        {
            let bound: CGFloat = 7
            let newPaper = Paper()
            newPaper.backgroundColor = NSColor.white
            let frame = view_.frame
            newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + bound, width: frame.size.width - 2*bound, height: frame.size.height - 2*bound)
            View.addSubview(newPaper)
            self.append(newPaper as! Element)
            return true
        }
        return false
    }
    
    mutating func save(to path: URL) -> Bool
    {
        let writeContext = self.merge(saveTo: path)
        writeContext.closePDF()
        return true
        
    }
    
    mutating func merge(saveTo URL: URL) -> CGContext
    {
        let arrayOfPdf = self.convertToPDF()
        let writeContext = CGContext.init(URL as CFURL, mediaBox: nil, nil)
        
        for ele in arrayOfPdf
        {
            if let provider = CGDataProvider(data: ele as CFData), let reference = CGPDFDocument(provider)
            {
                let pageCount = reference.numberOfPages
                var page: CGPDFPage
                var mediaBox: CGRect
                for index in 1...pageCount
                {
                    guard let getCGPDFPage = reference.page(at: index)
                        else
                    {
                        NSLog("Error occurred in creating page")
                        return writeContext!
                    }
                    page = getCGPDFPage
                    mediaBox = page.getBoxRect(.mediaBox)
                    writeContext!.beginPage(mediaBox: &mediaBox)
                    writeContext!.drawPDFPage(page)
                    writeContext!.endPage()
                }
            }
        }
        return writeContext!
    }
    
    mutating func convertToPDF() -> [NSData]
    {
        var result = [NSData]()
        for ele in self
        { /*
            let rep = ele.bitmapImageRepForCachingDisplay(in: ele.bounds)
            ele.cacheDisplay(in: ele.bounds, to: rep!)
            let img = NSImage(size: ele.bounds.size)
            img.addRepresentation(rep!)
            let imgView: NSImageView = NSImageView(frame: ele.bounds)
            imgView.image = img
            */
            let imgView: NSImageView = NSImageView(frame: ele.bounds)
            imgView.image = ele.img
            
            if let pdfData: NSData = imgView.dataWithPDF(inside: imgView.frame) as NSData?
            {
                result.append(pdfData)
            }
        }
        return result
        
    }
    
    mutating func getData(fromPdf url: String) -> Bool
    {
        var error = false;
        return error;
        
    }
}

