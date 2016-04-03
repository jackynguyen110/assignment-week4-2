//
//  LoginViewController.swift
//  TwitterClient-Assignment#3
//
//  Created by jacky nguyen on 3/26/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onLoginTapped(sender: AnyObject) {
            TwitterClient.shareInstance.login({ () -> () in
                print("i've got logged in")
                self.performSegueWithIdentifier("containerSegue", sender: self)
                }) { (error:NSError) -> () in
                    print(error.localizedDescription)
        }
    }
}
