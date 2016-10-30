//
//  PostDetailViewController.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/29/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet weak var postImageView: UIImageView!

    var post: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let photos = (post?.value(forKey: "photos") as? NSArray)?[0] as? NSDictionary
        let photo = photos?.value(forKey: "original_size") as? NSDictionary
        let imageUrl = NSURL(string: photo?["url"] as! String) as! URL
        
        postImageView.setImageWith(imageUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
