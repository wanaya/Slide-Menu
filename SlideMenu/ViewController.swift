//
//  ViewController.swift
//  SlideMenu
//
//  Created by Guillermo Anaya Magallón on 09/10/14.
//  Copyright (c) 2014 wanaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var navDelegate: SlideProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        let leftButton = UIButton(frame: CGRectMake(10, 100, 100, 35))
        leftButton.setTitle("Left", forState: .Normal)
        leftButton.addTarget(self, action: "tapLeft", forControlEvents: .TouchUpInside)
        self.view.addSubview(leftButton)
        
        let rightButton = UIButton(frame: CGRectMake(200, 100, 100, 35))
        rightButton.setTitle("Right", forState: .Normal)
        rightButton.addTarget(self, action: "tapRight", forControlEvents: .TouchUpInside)
        self.view.addSubview(rightButton)
    }
    
    func tapLeft() {
        if let d = self.navDelegate {
            d.movePanelLeft()
        }
        
    }
    
    func tapRight() {
        if let d = self.navDelegate {
            d.movePanelRight()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

