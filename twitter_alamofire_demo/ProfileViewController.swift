//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michelle Caplin on 3/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    
    var user: User?
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    
    
    var tweetNum = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.current {
        
            let urlProfile = URL(string: (user.profileImage))
            print (user.profileImage)
            profileImage.af_setImage(withURL: urlProfile!)
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        
            if let bannerStr = user.profileBanner {
                let urlBanner = URL(string: (bannerStr))
                banner.af_setImage(withURL: urlBanner!)
            }
            
            nameLabel.text = user.name
            handleLabel.text = "@" + (user.screenName)
            bioLabel.text = user.description

            tweetsLabel.text = String(describing: user.statusesCount) + " Tweets"

            followingLabel.text = String(describing: user.followingCount) + " Following"
            followersLabel.text = String(describing: user.followersCount) + " Followers"

            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100
            
            getTweets()
        // Do any additional setup after loading the view.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getTweets() {
        if tweetNum > 200 {
            tweetNum = 200
        }
        APIManager.shared.getUserTimeLine(numTweets: tweetNum) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
