//
//  tweetTableViewCell.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 3/26/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class tweetTableViewCell: UITableViewCell {

    @IBOutlet weak var topIcon: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var tweet:Tweet! {
        didSet {
            
            if let retweet = tweet.retweet {
                if let name = tweet.user?.name {
                    topLabel.text = "\(name) retweeted"
                    topIcon.image = UIImage(named: "RetweetOn")
                }
                tweet = retweet
            }
            else if let replyTweetName = tweet.replyToScreenName {
                topLabel.text = "In reply to @\(replyTweetName)"
                topIcon.image = UIImage(named: "ReplyHover")
            }
            
            nameLabel.text = tweet.user?.name
            if let screenName = tweet.user?.screenName {
                screenNameLabel.text = "@\(tweet.user?.name)"
            }
            
            contentLabel.text = tweet.text
            profileImage.setImageWithURL((tweet.user?.profileImageUrl)!)
            
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "Retweet_on"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "Retweet"), forState: .Normal)
            }
            
            if tweet.isFavorited {
                favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
      // MARK: Action button
    
    @IBAction func onRetweet(sender: UIButton) {
        
        if let selectedTweetCell = sender.superview?.superview as? tweetTableViewCell   {
            let selectedTweet = selectedTweetCell.tweet
            if selectedTweet.isRetweeted {
                TwitterClient.shareInstance.getRetweetedId(selectedTweet.id!, completion: { (retweetedId, error) -> () in
                    if let myRetweetId = retweetedId {
                        TwitterClient.shareInstance.unretweet(myRetweetId, completion: { (response, error) -> () in
                            if response != nil {
                                selectedTweet.isRetweeted = false
                                self.retweetButton.setImage(UIImage(named: "retweet-1"), forState: .Normal)
                            }
                        })
                    }
                })
            } else {
                TwitterClient.shareInstance.retweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isRetweeted = true
                        self.retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
                    }
                })
            }

        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        if let selectedTweetCell = sender.superview?.superview as? tweetTableViewCell {
           let selectedTweet = selectedTweetCell.tweet
            if selectedTweet.isFavorited {
                TwitterClient.shareInstance.unfavoriteTweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isFavorited = false
                        self.favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
                    }
                })
            } else {
                TwitterClient.shareInstance.favoriteTweet(selectedTweet.id!, completion: { (response, error) -> () in
                    if response != nil {
                        selectedTweet.isFavorited = true
                        self.favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
                    }
                })
            }

        }
    }
}
