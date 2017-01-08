//
//  VisualizingPenSize.swift
//  NPaper
//
//  Created by LE  Nhut on 12/20/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Cocoa

class VisualizingPenSize: NSView {

    var size : CGFloat = 1.0
    var path = NSBezierPath()
    var color = NSColor.black
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
       
        drawPiechart()
    }
    
   func drawPiechart()
   {
  
    let rect = self.frame
    
    // 1
    let circle = NSBezierPath(ovalIn: rect)
    
    color.set()
    circle.stroke()
    circle.fill()
    
    // 2
    let path = NSBezierPath()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = rect.size.width / 2.0
    path.move(to: center)
    path.line(to: CGPoint(x: rect.maxX, y: center.y))
    path.close()
    
    // 3
    path.stroke()
    
    }
}
