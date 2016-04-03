//
//  tweet.swift
//  twitterAppTest
//
//  Created by jacky nguyen on 3/25/16.
//  Copyright © 2016 jackyCode.com. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: NSNumber?
    var user: User?
    var replyToStatusId: NSNumber?
    var replyToScreenName: String?
    var text: String?
    var timeStamp: NSDate?
    var retweetcount: Int = 0
    var favoritesCount: Int = 0
    var isRetweeted = false
    var isFavorited = false
    var retweet: Tweet?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? NSNumber!
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as! String?
        replyToStatusId = dictionary["in_reply_to_status_id"] as? NSNumber!
        replyToScreenName = dictionary["in_reply_to_screen_name"] as? String!

        let timeStampString = dictionary["created_at"] as! String?
        
        let formater = NSDateFormatter()
        formater.dateFormat = "EEE MM d HH:mm:ss Z y"
        
        timeStamp = formater.dateFromString(timeStampString!)
        isRetweeted = (dictionary["retweeted"] as? Bool!)!
        isFavorited = (dictionary["favorited"] as? Bool!)!
        retweetcount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        if let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary {
            retweet = Tweet(dictionary: retweetDictionary)
        }

    }
    
    class func tweetWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
 
}



