//
//  ContainerViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 4/2/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var ContentView: UIView!
    
    var originLeftMargin:CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            self.view.layoutIfNeeded()
            MenuView.addSubview(menuViewController.view)
        }
    }
    
    var currentViewController :UIViewController! {
        didSet(oldView) {
            //ContentView.addSubview(currentViewController.view)
            self.view.layoutIfNeeded()
            
            if oldView != nil {
                oldView.willMoveToParentViewController(nil)
                oldView.view.removeFromSuperview()
                oldView.didMoveToParentViewController(nil)
            }
            
            currentViewController.willMoveToParentViewController(self)
            ContentView.addSubview(currentViewController.view)
            currentViewController.didMoveToParentViewController(self)
            
            currentViewController.view.frame = CGRectMake(0, 0, ContentView.frame.size.width, ContentView.frame.size.height);
            
            UIView.animateWithDuration(0.5) { () -> Void in
                self.leftConstraint.constant = 0
                self.view.layoutIfNeeded()

            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // menuViewController = UIStoryboard.MenuController()
        //currentViewController = UIStoryboard.TwitterController()
        
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let transition = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            
            originLeftMargin = leftConstraint.constant
            
        } else if sender.state == .Changed {
            
            leftConstraint.constant = originLeftMargin + transition.x
            
        } else if sender.state == .Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.leftConstraint.constant = self.view.frame.width - 60
                } else {
                    self.leftConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
            
        }
    }
}

