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
    
    fileprivate var viewsArray = [Paper]()
    override func viewDidLoad()
    {
        ArrayOfPapperView.sharedInstance.addPaperSeries()
        
        ArrayOfPapperView.sharedInstance.addStyle1(for: 0, in: self.view)
        ArrayOfPapperView.sharedInstance.addStyle1(for: 0, in: self.view)
        
        
        
        
       // viewsArray.addStyle1(in: self.view)
    }
}



