//
//  ViewController.swift
//  NPaper
//
//  Created by LE  Nhut on 6/25/16.
//  Copyright © 2016 LE  Nhut. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {
    //@IBOutlet weak var drawingView: NDrawingView?
    
    @IBOutlet weak var rightContainerView: NSView!
    
    @IBOutlet weak var segmentViewController: NSSegmentedControl!
    var leftContainerController: leftViewController?
    var rightViews = [[Paper]]()
    
    @IBOutlet weak var rightView: RightView!
    @IBOutlet weak var leftContainerView: NSStackView!
    @IBOutlet weak var penSize: NSPopUpButton!
    @IBOutlet weak var colorTable: NSPopUpButton!
    
    @IBOutlet weak var horizonalScroller: NSScroller!
    @IBOutlet weak var Eraser: NSButton!
    @IBOutlet weak var sizeSlider: NSSlider!
    
    @IBOutlet weak var visualizingPenSize: NSView!
    
    private var isViewMode: Bool = false
    
    private var pencilSize: Float = 1.0
    private var eraserSize: Float = 1.0
    private var penButtonPressed = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame_ = NSMakeRect(0, 0, 792, 1122)
        self.rightView.documentView = NSView(frame: frame_)
        
        
        //set notification when nsscrollview is scrolled
      //  self.rightView.contentView.postsBoundsChangedNotifications = true
       // NotificationCenter.default.addObserver(self, selector: #selector(boundsDidChangeNotification), name: NSNotification.Name.NSViewBoundsDidChange, object: self.rightView.contentView)
      
        self.rightView.addNewPage(at: frame_)
        
        /*
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (aEvent) -> NSEvent? in
            self.keyUp(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
        */
        for ele in self.rightView.viewsArray
        {
            let point = NSMakePoint(self.rightView.documentVisibleRect.origin.x, self.rightView.documentVisibleRect.origin.y - horizonalScroller.frame.size.height)
            ele.scrollPoint = point
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
    /*
     override func viewDidLayout() {
     let frame_ = self.rightView.bounds
     self.rightView.viewsArray.resizeAllPapers(in: self.rightView.documentView!, with: frame_)
     }
     */
    /*
    func boundsDidChangeNotification(notification: NSNotification)
    {
        for ele in self.rightView.viewsArray
        {
            let point = NSMakePoint(self.rightView.documentVisibleRect.origin.x, self.rightView.documentVisibleRect.origin.y - horizonalScroller.frame.size.height)
            ele.scrollPoint = point
        }
    }*/
    
    @IBAction func addNewPage(_ sender: AnyObject) {
        let frame_ = NSMakeRect(0, 0, 792, 1122)
        self.rightView.addNewPage(at: frame_)
    }
    
    
    
    @IBAction func changedSize(_ sender: AnyObject) {
        let size = sizeSlider.floatValue
        rightView.viewsArray.captureScreens()
        if penButtonPressed == true
        {
            pencilSize = size
        }
        else
        {
            eraserSize = size
        }
        
        rightView.changePathSize(to: CGFloat.init(size))
    }
    
    //Change to View mode or change to edit mode
    @IBAction func isViewMode(_ sender: AnyObject) {
        isViewMode = !isViewMode
        //some code here
        
    }
    
    // Eraser
    @IBAction func Eraser(_ sender: AnyObject) {
        penButtonPressed = false
        rightView.viewsArray.captureScreens()
        let color = NSColor.white
        rightView.changePathColor(to: color)
        self.sizeSlider.floatValue = eraserSize
        self.sizeSlider.needsDisplay = true
        rightView.changePathSize(to: CGFloat.init(eraserSize))
        
    }
    
    @IBAction func Pen(_ sender: AnyObject) {
        penButtonPressed = true
        rightView.viewsArray.captureScreens()
        let color = NSColor.black
        rightView.changePathColor(to: color)
        self.sizeSlider.floatValue = pencilSize
        self.sizeSlider.needsDisplay = true
        rightView.changePathSize(to: CGFloat.init(pencilSize))
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject)
    {
        let savePanel =  NSSavePanel()
        rightView.viewsArray.captureScreens()
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
    
    @IBAction func OpenClicked(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["pdf"]
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose a file"
        openPanel.canChooseFiles = true;
        openPanel.begin(completionHandler: {(result:Int) in
            if(result == NSFileHandlingPanelOKButton)
            {
                let fileURL = openPanel.url!
                let pdfDocument = PDFDocument(url: fileURL)
                let frame_ = NSMakeRect(0, 0, 792, 1122)
                if let pages = pdfDocument?.pageCount
                {
                    var imgArray = [Paper]()
                    for pdfIndex in 0...pages
                    {
                        if let pagePdf = pdfDocument?.page(at: pdfIndex)
                        {
                            let data = pagePdf.dataRepresentation
                            if let tmp = NSImage(data: data)
                            {
                                let paper = Paper()
                                let img = NSImage(size: frame_.size)
                                img.lockFocus()
                                NSColor.white.set()
                                NSBezierPath.fill(frame_)
                                tmp.draw(at: NSZeroPoint, from: NSZeroRect, operation: NSCompositeSourceOver, fraction: 1.0)
                                img.unlockFocus()
                                paper.img = img
                                imgArray.append(paper)
                            }
                        }
                        
                    }
                    self.rightViews.append(imgArray)
                    self.rightView.displayWithViewsArray(viewarray: imgArray, with: frame_)
                }
                
            }
        })
    }
    
    @IBAction func segmentSelected(_ sender: AnyObject) {
        
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
     
     /*
     override func mouseEntered(with event: NSEvent) {
     let cursorSize = NSMakeSize(10, 10)
     let cursorImg = NSImage(size: cursorSize)
     cursorImg.lockFocus()
     NSColor.red.setFill()
     NSBezierPath.fill(NSMakeRect(0, 0, cursorSize.width, cursorSize.height))
     cursorImg.unlockFocus()
     let cursor = NSCursor(image: cursorImg, hotSpot: NSMakePoint(cursorSize.width/2, cursorSize.height/2))
     cursor.setOnMouseEntered(true)
     //self.addTrackingRect(self.bounds, owner: cursor, userData: nil, assumeInside: true)
     }*/
    
    override func keyDown(with event: NSEvent) {
        NSLog("%d \n", event.keyCode)
        if event.keyCode == 14
        {
            Eraser(self)
        }
    }
    
}

*/

/*
 extension NSViewController
 {
 override open func mouseDown(with event: NSEvent) {
 
 }
 
 override open func mouseDragged(with event: NSEvent) {
 
 }
 
 override open func mouseUp(with event: NSEvent) {
 
 }*/
 }

