//
//  CreateTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michelle Caplin on 3/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate: NSObjectProtocol {
    func did(post: Tweet)
}

class CreateTweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var placeHolder: UILabel!
    
    
    let charCount = UILabel()
    
    var toolBar = UIToolbar()
    weak var delegate: ComposeViewControllerDelegate?
    
    
    let blue = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1.0)
    let lightBlue = UIColor(red: 126/255, green: 187/255, blue: 252/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        textView.becomeFirstResponder()

        let url = URL(string: (User.current?.profileImage)!)
        profileImage.af_setImage(withURL: url!)
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        tweetButton.layer.cornerRadius = tweetButton.frame.height/2
        tweetButton.clipsToBounds = true
        
        tweetButton.backgroundColor = lightBlue
        tweetButton.isEnabled = false
        
        
        toolBar = UIToolbar(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 44))
        toolBar.barStyle = UIBarStyle.default

        
        charCount.text = "0/140"
        charCount.textColor = blue
        charCount.frame = CGRect(x: 0, y: 0, width: charCount.frame.width, height: 44)
        let barItem = UIBarButtonItem(customView: charCount)
        print(toolBar.frame.width)
        print(charCount.frame.width)

        toolBar.items = [barItem]

        toolBar.sizeToFit()
        
        textView.inputAccessoryView = toolBar

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        
        // The new text should be allowed? True/False
        let count = newText.characters.count
        charCount.text = String(count) + "/140"
        
        if count == 0 {
            placeHolder.textColor = UIColor.lightGray
            tweetButton.backgroundColor = lightBlue
            tweetButton.isEnabled = false
        }
        else {
            placeHolder.textColor = UIColor.clear
            tweetButton.backgroundColor = blue
            tweetButton.isEnabled = true
        }
        return count < characterLimit
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
    }
    
    
    @IBAction func tapTweet(_ sender: Any) {
        if textView.text.count > 0 {
            APIManager.shared.composeTweet(with: textView.text!) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            }
            dismiss(animated: true, completion: nil)
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
