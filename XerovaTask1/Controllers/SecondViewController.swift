//
//  SecondViewController.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/10/22.
//

import UIKit

enum ThumbState : String{
    case defaultState = "default", selfState = "self", nsfwState = "nsfw", contentState
}

class SecondViewController: UIViewController {
    
    @IBOutlet weak var postLabel: UITextView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var postTextHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageTopConstraint: NSLayoutConstraint!
    
    
    var postData:Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = ""
        postLabel.sizeThatFits(CGSize(width: postLabel.frame.size.width, height: postLabel.frame.size.height))
        postLabel.font = UIFont.boldSystemFont(ofSize: 18)
        postText.font = postText.font?.withSize(16)
        postLabel.text = postData?.data.title
        if postData?.data.selftext == "" {
            postText.isHidden = true
            //postImageTopConstraint = postLabel.bottomAnchor.constraint(equalTo: self.postLabel.bottomAnchor)
        }
        else{
            postText.text = postData?.data.selftext
        }
        postLabelHeight.constant = self.postLabel.contentSize.height
        postTextHeight.constant = self.postText.contentSize.height
        
        
        let dataThumbState = getThumbState(thumbString: postData?.data.thumbnail ?? "default")
        
        switch dataThumbState{
        case .defaultState:
            postImage.image = nil
        case .selfState:
            postImage.image = nil
        case .nsfwState:
            postImage.image = nil
        default:
            postImage.loadFrom(URLAddress: postData?.data.url ?? "https://www.baloglu.com/themes/canvas-1/img/no-image.png")
        }
        
    }
    func getThumbState(thumbString: String) -> ThumbState{
        if thumbString == ThumbState.defaultState.rawValue{
            return .defaultState
        }
        else if thumbString == ThumbState.selfState.rawValue{
            return .selfState
        }
        else if thumbString == ThumbState.defaultState.rawValue{
            return .nsfwState
        }
        else{
            return .contentState
        }
    }
}

//if postData?.data.thumbnail == ThumbState.defaultState.rawValue || postData?.data.thumbnail == "self" || postData?.data.thumbnail == "nsfw"{
//    postImage.image = nil
//}
//else{
//    postImage.loadFrom(URLAddress: postData?.data.url ?? "https://www.baloglu.com/themes/canvas-1/img/no-image.png")
//}
//postImage.loadFrom(URLAddress: "https://pbs.twimg.com/profile_images/1498641868397191170/6qW2XkuI_400x400.png")
