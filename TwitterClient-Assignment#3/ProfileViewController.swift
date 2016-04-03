//
//  ProfileViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 4/2/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var userName: String = ""
    //var userInfo: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!

    var tweets:[Tweet]!
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.reloadTable()
        tableView.tableFooterView=nil
        tableView.estimatedRowHeight = 228
        tableView.rowHeight = UITableViewAutomaticDimension

        pullToRefresh()
        refreshProfile()
        
        if let displayName = User.currentUser?.name {
            userName = displayName
        }

    }
    
    func reloadTable() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                
        }
        refreshControl?.endRefreshing()
        
    }
    
    
    func refreshProfile() {
        let param = ["screen_name" : userName]
        TwitterClient.shareInstance.showUserCompletionWithParams(param, completion: { (user, error) -> () in
            
            self.nameLabel.text = user?.name

            if let profileImageUrl = user?.profileImageUrl {
                self.profileImageView.setImageWithURL(profileImageUrl)
            }

            if let tweetCount = user?.statusesCount {
                self.tweetCountLabel.text = "\(tweetCount)"
            }
            if let followingCount = user?.followingCount {
                self.followingCountLabel.text = "\(followingCount)"
            }
            if let followerCount = user?.followerCount {
                self.followerCountLabel.text = "\(followerCount)"
            }
        })
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 222/255, green: 243/255, blue: 255/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let tweets = self.tweets{
                return tweets.count
            } else {
                return 0
            }

    }
    
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "reloadTable", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }

}
