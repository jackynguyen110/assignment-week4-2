//
//  twitterViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 3/26/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class twitterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "reloadTable", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.shareInstance.logOut()
    }
    func reloadTable() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                
        }
        refreshControl?.endRefreshing()
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets{
            return tweets.count
        } else {
            return 0
        }
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
    
    // MARK: Transfer between 2 view controllers
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if navigationController.topViewController is DetailViewController {
            let detailViewController = navigationController.topViewController as! DetailViewController
            //detailViewController.delegate = self
            
            var indexPath: AnyObject!
            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            detailViewController.selectedTweet = tweets[indexPath!.row]
            detailViewController.indexPath = indexPath! as? NSIndexPath
        } else
        if navigationController.topViewController is UpdateViewController {
            let updateViewController = navigationController.topViewController as! UpdateViewController
            //updateViewController.delegate = self
            
            if segue.identifier == "replySegue" {
                           }
        }
    }

}
