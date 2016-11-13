//
//  ArrayOfPapperViews.swift
//  NPaper
//
//  Created by LE  Nhut on 11/11/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Foundation
import Cocoa

class ArrayOfPapperView: NSObject
{
    fileprivate var pManager: [paperManager]
    
    class var sharedInstance: ArrayOfPapperView
    {
        struct Singleton
        {
            static let instance = ArrayOfPapperView()
        }
        return Singleton.instance
    }
    func getPapers(at index: Int) -> paperManager
    {
        if(index >= pManager.count)
        {
            return paperManager()
        }
        return pManager[index]
    }
    func addPaperSeries()
    {
        var newPaperSeries = paperManager()
        pManager.append(newPaperSeries)
    }
    override init()
    {
        pManager = [paperManager]()
        super.init()
    }
    
    func addStyle1(for index: Int, in View: NSView) -> Bool
    {
        if(pManager.count <= index)
        {
           return false
        }
        return pManager[index].addStyle1(in: View)
    }
    
    func addStyle2(for index: Int, in View: NSView) -> Bool
    {
        if(pManager.count <= index)
        {
            return false
        }
        return pManager[index].addStyle2(in: View)
    }
    func output(for element: Int, to URL: URL) -> Bool
    {
        if(element >= pManager.count)
        {
            return false
        }
        if let data: CGContext = pManager[element].merge(saveTo: URL)
        {
            data.closePDF()
            return true
        }
        return false
    }
    func getPaper(at index: Int) -> [Paper]
    {
        if(pManager.count <= index)
        {
            return [Paper]()
        }
        return pManager[index].getArray()
    }
    
}


class paperManager: NSObject {
    fileprivate var array = [Paper]()
    
    func getArray() -> [Paper]
    {
        return array
    }

    func addStyle1(in View: NSView) -> Bool
    {
        let bound: CGFloat = 7
        let newPaper = Paper()
        newPaper.backgroundColor = NSColor.white
        if (array.count == 0)
        {
            let frame = View.frame
            newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + bound, width: frame.size.width - 2*bound, height: frame.size.height - bound)
        }
        else
        {
            if let frame = array.last?.frame
            {
                newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + frame.size.height + bound, width: frame.size.width - 2*bound, height: frame.size.height)
            }
            else {
                return false
            }
        }
        View.addSubview(newPaper)
        array.append(newPaper)
        return true
    }
    
    func addStyle2(in View: NSView) -> Bool
    {
        if let view_: NSView = View
        {
            let bound: CGFloat = 7
            let newPaper = Paper()
            newPaper.backgroundColor = NSColor.white
            let frame = View.frame
            newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + bound, width: frame.size.width - 2*bound, height: frame.size.height - 2*bound)
            View.addSubview(newPaper)
            array.append(newPaper)
            return true
        }
        return false
    }
    
    func convertToPDF() -> [Data]
    {
        var result = [Data]()
        for ele in array
        {
            //  NSLog("%s\t" , *ele.img)
            if let pdfData: Data  = ele.dataWithPDF(inside: ele.bounds)
            {
                result.append(pdfData)
            }
        }
        return result
        
    }

    func merge(saveTo URL: URL) -> CGContext
    {
        let arrayOfPdf = convertToPDF()
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

}

/*
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
                newPaper.frame = NSRect(x: frame.origin.x + bound, y: frame.origin.y + frame.size.height + bound, width: frame.size.width - 2*bound, height: frame.size.height)
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
 */
