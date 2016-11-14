//
//  rightViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 10/28/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Foundation
import Cocoa




class rightViewController: NSViewController
{
    var viewsArray = [Paper]()
   
    @IBOutlet var scrollView: NSScrollView!
    
    
    
    
    override func viewDidLoad()
    {
     //   self.ScrollView.isFlipped = true
        let frame = self.scrollView.contentView.frame
        self.scrollView.documentView?.frame = frame
        
        //set notification when nsscrollview is scrolled
        self.scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundsDidChangeNotification), name: NSNotification.Name.NSViewBoundsDidChange, object: self.scrollView.contentView)
        
        
        //test with 8 papers
        let n = 8
        for _ in 0...n
        {
            viewsArray.addStyle1(in: self.scrollView.documentView!)
        }
        
        
        
        
       // viewsArray.addStyle1(in: self.view)
    }
    
    override func scrollWheel(with event: NSEvent) {
        let visibleRect = self.scrollView.contentView.documentVisibleRect;
        NSLog("Visible rect:%s", NSStringFromRect(visibleRect));
        let currentScrollPosition = visibleRect.origin;
    }
    
    //set new point for papers when nsscroll is scrolled
    func boundsDidChangeNotification(notification: NSNotification)
    {
        for ele in viewsArray
        {
            ele.scrollPoint = self.scrollView.documentVisibleRect.origin
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
        var newPaper = Paper()
        newPaper.frame = frame
        self.append(newPaper as! Element)
        return true
    }
    mutating func addStyle1(in View: NSView) -> Bool
    {
        let bound: CGFloat = 7
        let newPaper = Paper()
        newPaper.backgroundColor = NSColor.white
        if (self.count == 0)
        {
            let frame = View.frame
            newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + bound, width: frame.size.width - 2*bound, height: frame.size.height - bound)
        }
        else
        {
            if let frame = self.last?.frame
            {
                newPaper.frame = NSRect(x: frame.origin.x, y: frame.origin.y + frame.size.height + bound, width: frame.size.width, height: frame.size.height)
                let frame_ = View.frame
                View.frame = NSMakeRect(frame_.origin.x, frame_.origin.y, frame_.size.width, frame_.size.height + frame.size.height + 2*bound)
            }
            else {
                return false
            }
        }
        View.addSubview(newPaper)
        self.append(newPaper as! Element)
        return true
    }
    mutating func addStyle2(in View: NSView) -> Bool
    {
        if let view_: NSView = View
        {
            let bound: CGFloat = 7
            let newPaper = Paper()
            newPaper.backgroundColor = NSColor.white
            let frame = View.frame
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
    
    mutating func convertToPDF() -> [Data]
    {
        var result = [Data]()
        for ele in self
        {
            
            //  NSLog("%s\t" , *ele.img)
            if let pdfData: Data = ele.dataWithPDF(inside: ele.bounds)
            {
                result.append(pdfData)
            }
        }
        return result
        
    }
    
    mutating func output(to URL: String) -> Bool
    {
        var error = false;
        return error
    }
    
    mutating func getData(fromPdf url: String) -> Bool
    {
        var error = false;
        return error;
        
    }
}

