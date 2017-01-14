//
//  NDrawingView.swift
//  NPaper
//
//  Created by LE  Nhut on 6/25/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//
import AppKit
import Cocoa

protocol PaperDelegate: class {
    func newFrame(sender : NSRect)
    func newPoint(send: CGPoint)
    
}

class Paper: NSView {
    //@IBOutlet weak var _image: NSImage!
    let diff = CGFloat(25)
    
    let savingAfterTimes = 5
    var countTimes = 0
    
    var lineWidth : CGFloat = 1
    var pts: [CGPoint] = [CGPoint(),CGPoint(), CGPoint(), CGPoint(), CGPoint()]
    var ctr: NSInteger = 0
    //  var oldFrame = NSZeroRect
    var img = NSImage()
    var scrollPoint = CGPoint()
    var color = NSColor.black
    
    private var firstPoint = NSPoint.zero
    private var lastPoint = NSPoint.zero
    private var path = NSBezierPath()
    weak var delegate: PaperDelegate?
    
    
    var savingPath: String = ""
    var name: String = ""
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // tempImage.drawInRect(dirtyRect)
        // Drawing code here.
        //  NSColor.white.setFill()
        //  NSRectFill(self.frame)
       /* let cursorSize = NSMakeSize(20, 20)
        let curImg = NSImage(named: "cursor.png")
        curImg?.size = cursorSize
        let cursor = NSCursor.init(image: curImg!, hotSpot: NSMakePoint(cursorSize.width/2.0, cursorSize.height/2.0))
        cursor.set()
        */
        color.set()
        path.stroke()
        path.lineWidth = lineWidth
        
        
    }
    
    override func mouseDown(with theEvent: NSEvent) {
       // let y = theEvent.keyCode
       // NSLog("\(theEvent.buttonNumber)")
        let frame_ = convert(frame, to: nil)
        countTimes += 1
        var point = theEvent.locationInWindow
        point.x -= (frame_.origin.x - frame.origin.x)
        point.y -= (frame.origin.y - scrollPoint.y + diff)
        firstPoint = point
        path.move(to: firstPoint)
        
        pts[0] = point
        ctr = 0
        
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        
        //var point = theEvent.locationInWindow
        let frame_ = convert(frame, to: nil)
        //NSLog("%.2f %.2f", frame_.origin.x,frame.origin.x)
        var point = theEvent.locationInWindow
        point.x -= (frame_.origin.x - frame.origin.x)
        point.y -= (frame.origin.y - scrollPoint.y + diff)
        ctr += 1
        pts[ctr] = point
        if (ctr == 4)
        {
            pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2.0, y: (pts[2].y + pts[4].y)/2.0)
            path.move(to: pts[0])
            path.curve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
            
            needsDisplay = true
            
            pts[0] = pts[3]
            pts[1] = pts[4]
            ctr = 1
        }
        lastPoint = point
        //NSLog("(%.2f,%.2f)", point.x,point.y)
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        let frame_ = convert(frame, to: nil)
        var point = theEvent.locationInWindow
        point.x -= (frame_.origin.x - frame.origin.x)
        point.y -= (frame.origin.y - scrollPoint.y + diff)
        lastPoint = point
        path.line(to: lastPoint)
        needsDisplay = true
        if countTimes == savingAfterTimes
        {
            screenShot()
            self.backgroundColor = NSColor.init(patternImage: img)
            ////
            path.removeAllPoints()
            countTimes = 0
            
        }
        firstPoint = NSPoint.zero
        lastPoint = NSPoint.zero
    }
   
    
}
extension NSView {
    
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
extension Paper
{
    func screenShot()
    {
        //let viewToCapture = self.window!.contentView!
        let rep = self.bitmapImageRepForCachingDisplay(in: bounds)
        self.cacheDisplay(in: bounds, to: rep!)
        
        img = NSImage(size: bounds.size)
        img.addRepresentation(rep!)
    }
    
    func save(at Path: String) -> Bool
    {
        
        return true
    }
    
}
extension NSImage
{
    var imagePDFRepresentation: Data?
    {
        var pdfData: Data? = nil
        if let arr:[NSImageRep] = self.representations
        {
            for var rep in arr
            {
                if(rep is NSPDFImageRep)
                {
                    pdfData = (rep as! NSPDFImageRep).pdfRepresentation
                    return pdfData
                }
            }
        }
        
        return pdfData
    }
    
}
