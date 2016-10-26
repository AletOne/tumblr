//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/25/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {

    let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    let endpoint: String = "humansofnewyork.tumblr.com"
    var data: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    self.data = responseDictionary
                    NSLog("response: \(responseDictionary)")
                }
            }
            
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
