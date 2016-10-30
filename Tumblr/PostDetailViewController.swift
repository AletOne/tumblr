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

    @IBAction func zoomPhoto(_ sender: Any) {
        performSegue(withIdentifier: "zoomPhoto", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! FullScreenPhotoViewController
        destinationViewController.photo = self.postImageView.image
    }
}
