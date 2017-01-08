//
//  ViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 6/25/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  //@IBOutlet weak var drawingView: NDrawingView?
    
    @IBOutlet weak var rightContainerView: NSView!
   
    var leftContainerController: leftViewController?
    
    @IBOutlet weak var rightView: RightView!
    @IBOutlet weak var leftContainerView: NSStackView!
    @IBOutlet weak var penSize: NSPopUpButton!
    @IBOutlet weak var colorTable: NSPopUpButton!
    
    @IBOutlet weak var Eraser: NSButton!
    @IBOutlet weak var sizeSlider: NSSlider!
    
    @IBOutlet weak var visualizingPenSize: NSView!
    
    private var isViewMode: Bool = false
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let frame_ = self.rightView.frame
        self.rightView.documentView? = NSView(frame: frame_)
        //self.scrollView.documentView?.frame = frame
        
        //set notification when nsscrollview is scrolled
        self.rightView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundsDidChangeNotification), name: NSNotification.Name.NSViewBoundsDidChange, object: self.rightView.contentView)
        
        
        //test with 8 papers
        let n = 4
        for _ in 0...n
        {
            self.rightView.viewsArray.addStyle1(in: self.rightView.documentView!, with: frame_)
        }

        // Do any additional setup after loading the view.
    }

        override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func viewWillAppear() {
        
    }
    
    func boundsDidChangeNotification(notification: NSNotification)
    {
        for ele in self.rightView.viewsArray
        {
            ele.scrollPoint = self.rightView.documentVisibleRect.origin
        }
    }

    

    @IBAction func changedSize(_ sender: AnyObject) {
        let size = sizeSlider.floatValue
        
        
        rightView.changePathSize(to: CGFloat.init(size))
    }

//Change to View mode or change to edit mode
    @IBAction func isViewMode(_ sender: AnyObject) {
        isViewMode = !isViewMode
        //some code here
        
    }  
    
// Eraser
    @IBAction func Eraser(_ sender: AnyObject) {
        let color = NSColor.white
        rightView.changePathColor(to: color)

    }
    
    @IBAction func Pen(_ sender: AnyObject) {
        let color = NSColor.black
        rightView.changePathColor(to: color)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject)
    {
        let savePanel =  NSSavePanel()
        if(savePanel.runModal() == NSFileHandlingPanelOKButton)
        {
            
            let name = savePanel.nameFieldStringValue
            if let saveURL = savePanel.url?.appendingPathExtension("pdf")
            {
                rightView.viewsArray.save(to: saveURL)
            }
           
            
            
            /*
            let storyBoard = NSStoryboard(name: "Main", bundle: nil)
            let testStoryboard = storyBoard.instantiateController(withIdentifier: "testViewWindowController") as! NSWindowController
            if let testWindow: NSWindow = testStoryboard.window
            {
                let testView = testWindow.contentViewController
                testView?.view = (rightContainerController?.viewsArray[0])!
                let application = NSApplication.shared()
                application.runModal(for: testWindow)
            }*/
            
           // NSLog("%s", saveURL as! String)
            
        }
        
        
    }
    /*
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "rightSegue"
        {
            rightContainerController = segue.destinationController as? rightViewController
        }
        else if segue.identifier == "leftSegue"
        {
            leftContainerController = segue.destinationController as? leftViewController
        }
        
    }
 
*/
}
 
/*
extension NSViewController
{
    override open func mouseDown(with event: NSEvent) {
        
    }
    
    override open func mouseDragged(with event: NSEvent) {
        
    }
    
    override open func mouseUp(with event: NSEvent) {
        
    }
}*/
 

