//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/25/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    let endpoint: String = "humansofnewyork.tumblr.com"
    var data: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPosts(endpoint: self.endpoint)
    }
    
    func getPosts(endpoint: String) {
        let url = URL(string: "https://api.tumblr.com/v2/blog/\(endpoint)/posts/photo?api_key=\(self.apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.successCallback(responseDictionary: responseDictionary)
                }
            }
            
        })
        task.resume()
    }
    
    func successCallback(responseDictionary: NSDictionary) {
        self.data = (responseDictionary.value(forKey: "response") as? NSDictionary)?.value(forKey: "posts") as! NSArray
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = data[indexPath.row] as? NSDictionary
        let photos = (post?.value(forKey: "photos") as? NSArray)?[0] as? NSDictionary
        let photo = photos?.value(forKey: "original_size") as? NSDictionary
        let imageUrl = NSURL(string: photo?["url"] as! String) as! URL
        
        cell.postImageView.setImageWith(imageUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data.count
    }

}
