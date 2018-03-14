//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michelle Caplin on 3/13/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import DateToolsSwift
import ActiveLabel

class DetailViewController: UIViewController {
    
    @IBOutlet weak var activeTweetTextLabel: ActiveLabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedIcon: UIImageView!
    
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var retweetIcon: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        
        if tweet.favorited == false  {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    self.tweet.favorited = true
                    let numFavorites = self.tweet.favoriteCount ?? 0
                    self.tweet.favoriteCount = numFavorites + 1

                    self.refreshData()
                }
            }
            
        }
        else {
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.tweet.favorited = false
                    let numFavorites = self.tweet.favoriteCount ?? 0
                    self.tweet.favoriteCount = numFavorites - 1
                    self.refreshData()
                }
            }
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if tweet.retweeted == false {
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    self.tweet.retweeted = true
                    let numRetweets = self.tweet.retweetCount
                    self.tweet.retweetCount = numRetweets + 1

                    self.refreshData()
                }
            }
        }
        else {
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    self.tweet.retweeted = false
                    let numRetweets = self.tweet.retweetCount
                    print(numRetweets)
                    self.tweet.retweetCount = numRetweets - 1

                    self.refreshData()
                }
            }
        }
    }
    
    
    
    
    func refreshData() {

        if tweet.isRetweet {
            retweetedLabel.text = (tweet.retweetedByUser?.name)! + " Retweeted"
            retweetedIcon.image = UIImage(named: "retweet-icon")
            
        }
        else {
            retweetedIcon.image = nil
            retweetedLabel.text = nil
            
        }
        if tweet.favorited {
            favoriteIcon.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            favoritesLabel.textColor = .red
        }
        else {
            favoriteIcon.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
            favoritesLabel.textColor = .black
        }
        if tweet.retweeted {
            retweetIcon.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            let green = UIColor(red:0.0, green:204.0/255.0, blue:153.0/255.0, alpha:1.0)
            retweetsLabel.textColor = green
        }
        else {
            retweetIcon.setImage(UIImage(named: "retweet-icon"), for: .normal)
            retweetsLabel.textColor = .black
        }
        activeTweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
        activeTweetTextLabel.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        activeTweetTextLabel.handleURLTap { (url) in
            UIApplication.shared.open(url, options: [:])
        }
        //let col = self.tintColor
        let col = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        activeTweetTextLabel.hashtagColor = col
        activeTweetTextLabel.mentionColor = col
        activeTweetTextLabel.URLColor = col
        activeTweetTextLabel.text = tweet.text
        
        usernameLabel.text = tweet.user.name
        handleLabel.text = "@" + tweet.user.screenName
        
        let date = tweet.createdAtDate

        let timeAgo = date.shortTimeAgoSinceNow
        dateLabel.text = "• " + timeAgo
        if tweet.retweetCount == 0 {
            retweetsLabel.text = ""
        }
        else {
            retweetsLabel.text = String(tweet.retweetCount)
        }
        let numFavorites = tweet.favoriteCount ?? 0
        if numFavorites == 0 {
            favoritesLabel.text = ""
        }
        else {
            favoritesLabel.text = String(numFavorites)
        }
        let url = URL(string: tweet.user.profileImage)
        profileImage.af_setImage(withURL: url!)
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
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
