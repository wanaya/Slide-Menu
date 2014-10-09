//
//  NavViewController.swift
//  SlideMenu
//
//  Created by Guillermo Anaya Magallón on 09/10/14.
//  Copyright (c) 2014 wanaya. All rights reserved.
//

import UIKit
import QuartzCore

protocol SlideProtocolDelegate {
    func movePanelLeft()
    func movePanelRight()
    func movePanelToOriginalPosition()
}

protocol SlideMoveProtocolDelegate {
    func openCenterController(controller: UIViewController)
}

enum SSlideMenuState {
    case Closed
    case LeftOpened
    case RightOpened
}

enum SPaningState {
    case Stopped
    case Left
    case Right
}

class NavViewController: UIViewController {
    
    let centerTag = 1
    let leftTag = 2
    let rightTag = 3
    let cornerRadius = CGFloat(4)
    let slideTiming = 0.25
    var panelWidth = CGFloat(270)
    
    var panStarted = false
    var posYNav = CGFloat(0)
    var preVelocity = CGPoint(x: 0, y: 0)
    var menuState = SSlideMenuState.Closed
    var panningState = SPaningState.Stopped
    
    var panRecognizer = UIPanGestureRecognizer()
    
    lazy var centerViewController: ViewController = ViewController()
    lazy var leftPanelViewController = LeftViewController()
    lazy var rightPanelViewController = RightViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        panelWidth = self.view.bounds.width - 50
        self.centerViewController.view.tag = centerTag
        self.centerViewController.view.bounds = self.view.bounds
        self.centerViewController.navDelegate = self
        self.addChildViewController(self.centerViewController)
        self.centerViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(self.centerViewController.view)
        
        self.setupGestures()
    }
    
    func leftView() -> UIView {
        if self.leftPanelViewController.view.tag != leftTag {
            self.leftPanelViewController.view.tag = leftTag;
            self.leftPanelViewController.delegate = self
            
            self.addChildViewController(self.leftPanelViewController)
            self.leftPanelViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.view.addSubview(self.leftPanelViewController.view)
        }
        
        self.showCenterViewWithShadow(true, withOffset: 2)
        
        return self.leftPanelViewController.view
    }
    
    func rightView() -> UIView {
        if self.rightPanelViewController.view.tag != rightTag {
            self.rightPanelViewController.view.tag = rightTag
            self.rightPanelViewController.delegate = self
            
            self.addChildViewController(self.rightPanelViewController)
            self.rightPanelViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.view.addSubview(self.rightPanelViewController.view)
        }
        
        self.showCenterViewWithShadow(true, withOffset: 2)
        return self.rightPanelViewController.view
    }
    
    func showCenterViewWithShadow(value :Bool, withOffset offset:CGFloat) {
        if value {
            self.centerViewController.view.layer.cornerRadius = cornerRadius
            self.centerViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
            self.centerViewController.view.layer.shadowOpacity = 0.8
            self.centerViewController.view.layer.shadowOffset = CGSizeMake(offset, offset)
        }
        else {
            self.centerViewController.view.layer.cornerRadius = 0
            self.centerViewController.view.layer.shadowOffset = CGSizeMake(offset, offset)
            self.centerViewController.view.layer.shadowOpacity = 0
        }
    }
    
    
    func movePanelLeft() {
        
        let childView = self.leftView()
        self.view.sendSubviewToBack(childView)
        var frame = self.centerViewController.view.frame
        frame.origin.x = panelWidth
        if var frameNav = self.navigationController?.navigationBar.frame {
            self.posYNav = frameNav.origin.y
            frameNav.origin.x = panelWidth
            
            UIView.animateWithDuration(slideTiming, delay: Double(0), options: .BeginFromCurrentState, animations:{
                self.centerViewController.view.frame = frame
                self.navigationController?.navigationBar.frame = frameNav
                
                }, completion: {
                    finished in
                    if finished {
                        self.menuState = SSlideMenuState.LeftOpened
                    }
            })
        }
    }
    
    
    func movePanelRight() {
        let childView = self.rightView()
        self.view.sendSubviewToBack(childView)
        var frame = self.centerViewController.view.frame
        frame.origin.x = -panelWidth
        if var frameNav = self.navigationController?.navigationBar.frame {
            self.posYNav = frameNav.origin.y
            frameNav.origin.x = -panelWidth
            
            UIView.animateWithDuration(slideTiming, delay: Double(0), options: .BeginFromCurrentState, animations:{
                self.centerViewController.view.frame = frame
                self.navigationController?.navigationBar.frame = frameNav
                
                }, completion: {
                    finished in
                    if finished {
                        self.menuState = SSlideMenuState.RightOpened
                    }
            })
        }
        
    }
    
    
    func movePanelToOriginalPosition() {
        var frame = self.centerViewController.view.frame
        frame.origin.x = 0
        
        if var frameNav = self.navigationController?.navigationBar.frame {
            frameNav.origin.x = 0
            frameNav.origin.y = self.posYNav
            
            UIView.animateWithDuration(slideTiming, delay: Double(0), options: .BeginFromCurrentState, animations:{
                self.centerViewController.view.frame = frame
                self.navigationController?.navigationBar.frame = frameNav
                
                }, completion: {
                    finished in
                    if finished {
                        self.resetMainView()
                    }
            })
        }
    }
    
    func resetMainView() {
        
        self.menuState = SSlideMenuState.Closed
        self.panningState = SPaningState.Stopped
        self.showCenterViewWithShadow(false, withOffset: 0)
        
        self.leftPanelViewController.view.tag = 0;
        self.leftPanelViewController.delegate = nil
        
        self.rightPanelViewController.view.tag = 0;
        self.rightPanelViewController.delegate = nil
        
        self.leftPanelViewController.view.removeFromSuperview()
        self.rightPanelViewController.view.removeFromSuperview()
    }
    
    func setupGestures() {
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "movePanel:")
        self.panRecognizer.minimumNumberOfTouches = 1
        self.panRecognizer.maximumNumberOfTouches = 1
        self.panRecognizer.delegate = self
        self.centerViewController.view.addGestureRecognizer(panRecognizer)
    }

}

extension NavViewController:SlideMoveProtocolDelegate {
    func openCenterController(controller: UIViewController) {
        
    }
}

extension NavViewController: SlideProtocolDelegate {
    
}

extension NavViewController: UIGestureRecognizerDelegate {
    func movePanel(tap: UIPanGestureRecognizer) {
        
        var panStartPosition = CGPoint(x: 0, y: 0)
        var panningView = tap.view
        
        if self.menuState != SSlideMenuState.Closed {
            panningView = panningView?.superview
        }
        
        let translation = tap.translationInView(panningView!)
        
        switch tap.state {
        case .Began:
            panStartPosition = tap.locationInView(panningView)
            panStarted = true
        case .Ended, .Cancelled:
            
            
            self.panningState = SPaningState.Stopped
        case .Changed:
            
            if panStartPosition == CGPoint(x: 0, y: 0) {
                let actualWidth = panningView?.frame.size.width
                if panStartPosition.x > actualWidth && panStartPosition.x < panningView!.frame.size.width - actualWidth! && self.menuState == SSlideMenuState.Closed {
                    return
                }
            }
            
            if self.panStarted {
                self.panStarted = false
                if panningView!.frame.origin.x + translation.x > 0 {
                    switch self.menuState {
                    case .RightOpened:
                        self.movePanelToOriginalPosition()
                    case .Closed:
                        self.movePanelLeft()
                    default:
                        println("error")
                        
                    }
                    self.panningState = SPaningState.Right
                } else if panningView!.frame.origin.x + translation.x < 0 {
                    switch self.menuState {
                    case .LeftOpened:
                        self.movePanelToOriginalPosition()
                    case .Closed:
                        self.movePanelRight()
                    default:
                        println("error")
                    }
                    self.panningState = SPaningState.Left
                }
            }
        default:
            println("\(tap.state)")
            
        }
    }
}
