//
//  DetailViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 3/27/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var topIcon: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyTextView: UITextView!
    
    @IBOutlet weak var replyTweetButton: UIButton!
    
    @IBOutlet weak var limitLabel: UILabel!
    
    var selectedTweet: Tweet?
    
    var indexPath: NSIndexPath?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        profileImage.layer.cornerRadius = 8
        profileImage.layer.masksToBounds = true
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHiden:"), name:UIKeyboardWillHideNotification, object: nil)
        
        self.setDetail()

    }
    
    @IBAction func onBackButton(sender: AnyObject) {
            dismissViewControllerAnimated(true, completion: nil)

    }
    func setDetail() {
        
        if let retweet = selectedTweet?.retweet {
            if let name = selectedTweet!.user?.name {
                topLabel.text = "\(name) retweeted"
                topIcon.image = UIImage(named: "RetweetOn")
            }
            selectedTweet = retweet
        }
        else if let replyTweetName = selectedTweet!.replyToScreenName {
            topLabel.text = "In reply to @\(replyTweetName)"
            topIcon.image = UIImage(named: "ReplyHover")
        }
        
        nameLabel.text = selectedTweet!.user?.name
        if let screenName = selectedTweet?.user?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        
        contentLabel.text = selectedTweet?.text
        profileImage.setImageWithURL((selectedTweet!.user?.profileImageUrl)!)
        
        if ((selectedTweet?.isRetweeted) != nil) {
            retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
        }
        
        if ((selectedTweet?.isFavorited) != nil) {
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
        }
    }
}
