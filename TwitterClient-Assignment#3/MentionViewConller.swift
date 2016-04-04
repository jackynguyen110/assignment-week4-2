//
//  MentionViewConller.swift
//  TwitterClient-Assignment#3
//
//  Created by DEREK DO on 4/4/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class MentionViewConller: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    var tweets:[Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImageView(image: UIImage(named: "WhiteLogo"))
        self.navigationItem.titleView = logo
        
        tableView.dataSource = self
        tableView.delegate = self
        self.reloadTable()
        tableView.tableFooterView=nil
        tableView.estimatedRowHeight = 228
        tableView.rowHeight = UITableViewAutomaticDimension
        pullToRefresh()
    }
  
    func reloadTable() {
        
        var userName = ""
        if let displayName = User.currentUser?.screenName {
            userName = displayName
        }

        let param = ["screen_name" : userName]

        TwitterClient.shareInstance.mentionTimeLine(param) { (data, error) -> () in
            if let data = data {
                self.tweets = data
                self.tableView.reloadData()
            }
        }
               refreshControl?.endRefreshing()
    }

    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "reloadTable", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
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
    
    
}
