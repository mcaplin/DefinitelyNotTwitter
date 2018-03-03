//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import DateToolsSwift
import ActiveLabel
//import TTTAttributedLabel

class TweetCell: UITableViewCell {


    @IBOutlet weak var activeTweetTextLabel: ActiveLabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //@IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedIcon: UIImageView!
    
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var retweetIcon: UIButton!
    
    

    var tweet: Tweet! {
        didSet {
            refreshData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*if tweet.favorited == true {
            print("favorited")
        }
        else {
            print("not")
        }*/
        //print(tweet.favorited)
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        //print (tweet.favorited)
        //self.tweet.favorited = false
        //refreshData()
        if tweet.favorited == false  {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    self.tweet.favorited = true
                    let numFavorites = self.tweet.favoriteCount ?? 0
                    print(numFavorites)
                    self.tweet.favoriteCount = numFavorites + 1
                    //self.favoritesLabel.text = String(self.tweet.favoriteCount)
                    //self.favoriteIcon.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
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
                    //self.favoriteIcon.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
                    self.refreshData()
                }
            }
            //print("already favorited")
         
        }
        
        //refreshData()
        
        print(tweet.favorited)
        print("ffffffffff")
 
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
                    print(numRetweets)
                    self.tweet.retweetCount = numRetweets + 1
                    //self.favoritesLabel.text = String(self.tweet.favoriteCount)
                    //self.favoriteIcon.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
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
                    //self.favoritesLabel.text = String(self.tweet.favoriteCount)
                    //self.favoriteIcon.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
                    self.refreshData()
                }
            }
        }
    }
    
    
    
    
    func refreshData() {
        //print ("refresh")
        if tweet.isRetweet {
            retweetedLabel.text = (tweet.retweetedByUser?.name)! + " Retweeted"
            retweetedIcon.image = UIImage(named: "retweet-icon")
            
        }
        else {
            retweetedIcon.image = nil
            retweetedLabel.text = nil
            
        }
        if tweet.favorited {
            print("favorited")
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
        //tweetTextLabel.text = tweet.text
        //attributedTweetTextLabel.text = tweet.text
        activeTweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
        activeTweetTextLabel.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        activeTweetTextLabel.handleURLTap { (url) in
            UIApplication.shared.open(url, options: [:])
        }
        let col = self.tintColor
        //let col = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        activeTweetTextLabel.hashtagColor = col!
        activeTweetTextLabel.mentionColor = col!
        activeTweetTextLabel.URLColor = col!
        activeTweetTextLabel.text = tweet.text
        usernameLabel.text = tweet.user.name
        handleLabel.text = "@" + tweet.user.screenName
        
        let date = tweet.createdAtDate
        //let timAgo = date.
        
        print(date)
        let timeAgo = date.shortTimeAgoSinceNow
        print(timeAgo)
        dateLabel.text = "• " + timeAgo//tweet.createdAtString
        retweetsLabel.text = String(tweet.retweetCount)
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
        /*
        retweetsLabel.text = String(tweet.retweetCount)
        let numFavorites = tweet.favoriteCount ?? 0
        if numFavorites == 0 {
            favoritesLabel.text = ""
        }
        else {
            favoritesLabel.text = String(numFavorites)
        }*/
    }
    /*func refreshData(tweet: Tweet) {
        Tweet.didSet {
            if tweet.isRetweet {
                retweetedLabel.text = (tweet.retweetedByUser?.name)! + " Retweeted"
                retweetedIcon.image = UIImage(named: "retweet-icon")
                
            }
            else {
                retweetedIcon.image = nil
                retweetedLabel.text = nil
                
            }
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            handleLabel.text = "@" + tweet.user.screenName
            dateLabel.text = "• " + tweet.createdAtString
            retweetsLabel.text = String(tweet.retweetCount)
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
    }*/
}
