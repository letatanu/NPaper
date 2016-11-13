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
    var rightContainerController : rightViewController?
    var leftContainerController: leftViewController?
    
    @IBOutlet weak var leftContainerView: NSStackView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Do any additional setup after loading the view.
    }

        override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func viewWillAppear() {
        
    }

    @IBAction func saveButtonClicked(sender: AnyObject)
    {
        
        
        let savePanel =  NSSavePanel()
        if(savePanel.runModal() == NSFileHandlingPanelOKButton)
        {
            
            let name = savePanel.nameFieldStringValue
            if let saveURL = savePanel.url?.appendingPathExtension("pdf")
            {
                ArrayOfPapperView.sharedInstance.output(for: 0, to: saveURL)
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
 

