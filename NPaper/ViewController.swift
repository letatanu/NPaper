//
//  ViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 6/25/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  @IBOutlet weak var drawingView: NDrawingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingView = NDrawingView()
        drawingView?.sizeToFit()
        drawingView?.image = NSImage(size: self.view.bounds.size)
        


        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

