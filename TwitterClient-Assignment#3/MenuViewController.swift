//
//  LeftViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 4/2/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    var viewController:[UIViewController] = [UIStoryboard.TwitterController()!, UIStoryboard.profileController()!,UIStoryboard.profileController()!,UIStoryboard.profileController()!]
    
    var containerViewController:ContainerViewController!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate   = self
        menuTableView.dataSource = self
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        containerViewController = storyBoard.instantiateViewControllerWithIdentifier("ContainerViewController") as? ContainerViewController
        
        menuTableView.separatorStyle = .None
        if let displayName = User.currentUser?.name {
            name.text = displayName
            
        }
        if let profileImageUrl = User.currentUser?.profileImageUrl {
            profileImageView.setImageWithURL(profileImageUrl)
        }
        profileImageView.layer.cornerRadius = CGRectGetWidth(profileImageView.frame) / 2;
        profileImageView.clipsToBounds = true;
        profileImageView.layer.borderWidth = 1.0
        //profileImageView.layer.borderColor = UIColor.blackColor()

    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuCell
        if indexPath.row == 0 {
            cell.sectionName.text = "Home"
        } else if indexPath.row == 1 {
            cell.sectionName.text = "Profile"
        } else if indexPath.row == 2 {
            cell.sectionName.text = "Mention"
        }
        else {
            cell.sectionName.text = "Sign Out"
        }
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        containerViewController.currentViewController = viewController[indexPath.row]    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    

}