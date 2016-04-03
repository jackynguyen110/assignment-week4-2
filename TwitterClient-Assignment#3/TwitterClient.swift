//
//  TweetClient.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 3/26/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager  {
    
    var loginSuccess : (() -> ())?
    var loginFailure : ((NSError) -> ())?
    
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "1q9ZuW7Kn9j1GSUctCOO2LZuh", consumerSecret: "TH7jVjkyQcy4Fv62ZOZTPaDVqkkgZ10JsoxYUEFgm8iDM9M1Gu")
    
    func homeTimeLine(success : ([Tweet]) -> (), failure : (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let tweets = Tweet.tweetWithArray(response as! [NSDictionary])
            success(tweets)
            }) { (session:NSURLSessionDataTask?, error:
                NSError) -> Void in
                failure(error)
        }
    }
    
    func login(success : () -> (), failure:(NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.shareInstance.deauthorize()
        TwitterClient.shareInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                print(error.localizedDescription)
        }
        
    }
    
    func showUserCompletionWithParams(params: NSDictionary?, completion: (user: User?, error: NSError?) ->()) {
        GET("1.1/users/show.json", parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let returnUser = User(dictionary: response as! NSDictionary)
                completion(user: returnUser, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error.localizedDescription)
                completion(user: nil, error: error)
        }
    }

    
    func currentAccount(success: (User) -> (), failure:(NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let user = User(dictionary: (response as? NSDictionary)!)
            success(user)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
    }
    
    func logOut() {
        User.currentUser =  nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func openURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("i got the access token")
            
            self.currentAccount({ (user:User) -> () in
                User.currentUser = user
                self.loginSuccess!()
                }, failure: { (error:NSError) -> () in
                    self.loginFailure!(error)
            })
           
            }) { (error : NSError!) -> Void in
                self.loginFailure?(error)
        }
        
    }
    
    func favoriteTweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        var params = [String : AnyObject]()
        params["id"] = id
        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            completion(response: response, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
             completion(response: nil, error: error)
        }
        
    }
    
    func unfavoriteTweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        var params = [String : AnyObject]()
        params["id"] = id
        POST("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            completion(response: response, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                completion(response: nil, error: error)
        }
    }
    
    // MARK: Retweet
    
    func retweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        let request = "1.1/statuses/retweet/\(id).json"
        POST(request, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            completion(response: response, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                completion(response: nil, error: error)
        }
    }
    
    func getRetweetedId(id: NSNumber, completion: (retweetedId: NSNumber?, error: NSError?) -> ()) {
        
        var retweetedId: NSNumber?
        
        var params = [String : AnyObject]()
        params["include_my_retweet"] = true
        
        
        GET("1.1/statuses/show/\(id).json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let tweet = response as! NSDictionary
            let curUserRetweet = tweet["current_user_retweet"] as! NSDictionary
            retweetedId = curUserRetweet["id"] as? NSNumber
            
            completion(retweetedId: retweetedId, error: nil)            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error.localizedDescription)
                completion(retweetedId: nil, error: error)        }
    }
    
    func unretweet(id: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        let request = "1.1/statuses/destroy/\(id).json"
        
        POST(request, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            completion(response: response, error: nil)
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                completion(response: nil, error: error)
        }

    }


}
