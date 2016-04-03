//
//  File.swift
//  twitterAppTest
//
//  Created by jacky nguyen on 3/24/16.
//  Copyright © 2016 jackyCode.com. All rights reserved.
//

import UIKit


let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"


class User : NSObject {
    
     static let userDidLogoutNotification = "userDidLogoutNotification"
    
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary
    var followerCount: Int?
    var followingCount: Int?
    var statusesCount: Int?
    var profileBannerUrl: String?

    
    init(dictionary:NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let imageURLString = dictionary["profile_image_url"] as? String
        if imageURLString != nil {
            profileImageUrl = NSURL(string: imageURLString!)
        } else {
            profileImageUrl = nil
        }
        
        tagline = dictionary["description"] as? String
        
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        profileBannerUrl = dictionary["profile_banner_url"] as? String


    }
    
    func logout() {
        
        User.currentUser = nil
        TwitterClient.shareInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        let dictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    
}
