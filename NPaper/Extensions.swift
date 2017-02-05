//
//  Extensions.swift
//  NPaper
//
//  Created by LE  Nhut on 1/8/17.
//  Copyright © 2017 LE  Nhut. All rights reserved.
//

import Foundation
import Cocoa
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
    mutating func addStyle1(in view: NSView, with rect: NSRect) -> Bool
    {
        if let View : NSView = view {
            let verticalBound: CGFloat = 0
            let horizontalBound: CGFloat = 2
            let newPaper = Paper()
            let frame = rect
            newPaper.backgroundColor = NSColor.white
            if (self.count == 0)
            {
                //let frame = rect
                newPaper.frame = NSRect(x: frame.origin.x + verticalBound, y: frame.origin.y + horizontalBound, width: frame.size.width, height: frame.size.height)
                
                
            }
            else
            {
                let frame_ = View.frame
                View.frame.size = NSMakeSize(frame_.size.width, frame_.size.height + frame.size.height + 2*horizontalBound)
                for ele in self
                {
                    let selfFrame = ele.frame
                    ele.frame.origin = NSMakePoint(selfFrame.origin.x, selfFrame.origin.y + frame.size.height + horizontalBound)
                }
                newPaper.frame = NSRect(x: verticalBound, y: horizontalBound, width: frame.size.width, height: frame.size.height)
                
            }
            
            //let trackingArea = NSTrackingArea.init(rect: newPaper.frame, options: NSTrackingAreaOptions.mouseEnteredAndExited, owner: newPaper, userInfo: nil)
            // newPaper.addTrackingArea(trackingArea)
            
            View.addSubview(newPaper)
            self.append(newPaper as! Element)
            return true
        }
        else
        {
            return false
        }
    }

    mutating func addPaper(at frame: NSRect, with image: NSImage, on view: NSView) -> Bool
    {
        if let View : NSView = view {
            let verticalBound: CGFloat = 0
            let horizontalBound: CGFloat = 2
            let newPaper = Paper()
            newPaper.backgroundColor = NSColor.white
            if (self.count == 0)
            {
                newPaper.frame = NSRect(x: frame.origin.x + verticalBound, y: frame.origin.y + horizontalBound, width: frame.size.width, height: frame.size.height)
                newPaper.backgroundColor = NSColor.init(patternImage: image)
            }
            else
            {
                let frame_ = View.frame
                View.frame.size = NSMakeSize(frame_.size.width, frame_.size.height + frame.size.height + 2*horizontalBound)
                for ele in self
                {
                    let selfFrame = ele.frame
                    ele.frame.origin = NSMakePoint(selfFrame.origin.x, selfFrame.origin.y + frame.size.height + horizontalBound)
                }
                newPaper.frame = NSRect(x: verticalBound, y: horizontalBound, width: frame.size.width, height: frame.size.height)
                 newPaper.backgroundColor = NSColor.init(patternImage: image)
                
            }
            
            //let trackingArea = NSTrackingArea.init(rect: newPaper.frame, options: NSTrackingAreaOptions.mouseEnteredAndExited, owner: newPaper, userInfo: nil)
            // newPaper.addTrackingArea(trackingArea)
            
            View.addSubview(newPaper)
            self.append(newPaper as! Element)
            return true
        }
        else
        {
            return false
        }

    }
    mutating func captureScreens()
    {
        for ele in self
        {
            ele.screenShot()
            ele.backgroundColor = NSColor.init(patternImage: ele.img)
            ////
            ele.path.removeAllPoints()
            ele.countTimes = 0        }
    }
    
    /*
     mutating func resizeAllPapers(in View: NSView, with frameSize: NSRect)
     {
     let verticalBound: CGFloat = 0
     let horizontalBound: CGFloat = 2
     
     let size = self.count
     if size == 0
     {
     return
     }
     else if size == 1
     {
     let curView = self[0]
     curView.frame = NSRect(x: frameSize.origin.x + verticalBound, y: frameSize.origin.y + horizontalBound, width: frameSize.size.width - 2*verticalBound, height: frameSize.size.height - horizontalBound)
     
     }
     else
     {
     for i in 1...size-1
     {
     let curView = self[i]
     let preView = self[i-1]
     let frame = preView.frame
     let frame_ = View.frame
     View.frame = NSMakeRect(frame_.origin.x, frame_.origin.y, frame_.size.width, frame_.size.height + frame.size.height + 2*horizontalBound)
     curView.frame = NSRect(x: frame.origin.x, y: frame.origin.y + frame.size.height + horizontalBound, width: frame.size.width, height: frame.size.height)
     
     }
     }
     }
     */
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

extension NSRect
{
    func A4Size() -> NSSize
    {
        return NSMakeSize(792, 1122)
    }
    
    func A4Frame() -> NSRect
    {
        return NSMakeRect(0, 0, 792, 1122)
    }
}
