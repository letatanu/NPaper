//
//  NDrawingView.swift
//  NPaper
//
//  Created by LE  Nhut on 6/25/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Cocoa

class NDrawingView: NSImageView {
    //@IBOutlet weak var _image: NSImage!
    var firstPoint = NSPoint.zero
    var lastPoint = NSPoint.zero
    var path = NSBezierPath()
    var lineWidth : CGFloat = 1
    var pts: [CGPoint] = [CGPoint(),CGPoint(), CGPoint(), CGPoint(), CGPoint()]
    var ctr: NSInteger = 0
    
    var tempImage = NSImage()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
       // tempImage.drawInRect(dirtyRect)
        // Drawing code here.
        NSColor.white.setFill()
        NSRectFill(self.frame)
        NSColor.black.set()
        path.stroke()
        path.lineWidth = lineWidth
        
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        var point = theEvent.locationInWindow
        point.x -= frame.origin.x
        point.y -= frame.origin.y
        firstPoint = point
        path.move(to: firstPoint)
        
        pts[0] = point
        ctr = 0
        
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        
        var point = theEvent.locationInWindow
        point.x -= frame.origin.x
        point.y -= frame.origin.y
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
        
        var point = theEvent.locationInWindow
        point.x -= frame.origin.x
        point.y -= frame.origin.y
        lastPoint = point
        path.line(to: lastPoint)
        needsDisplay = true
        drawBitMap()
        
        self.image = NSImage()
        self.image = tempImage
        path.removeAllPoints()
    }
    
    func drawBitMap()
    {
       self.lockFocus()
        
        let bitmap = NSBitmapImageRep(focusedViewRect: self.bounds)
        //let bitmap = NSImage.init(data: self.dataWithPDF(inside: self.bounds))
        self.unlockFocus()
        
        //tempImage = NSImage(size: self.bounds.size)
        
        if let tt = bitmap
        {
            //tempImage = tt
            tempImage.addRepresentation(tt)
        }
    }
}
