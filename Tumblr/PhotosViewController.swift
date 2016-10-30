//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/25/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    let endpoint: String = "humansofnewyork.tumblr.com"
    var data: [NSDictionary] = []
    var loading = false
    var loadingView:InfiniteScrollActivityView?
    var stopIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        tableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(origin: CGPoint(x: 0,y: tableView.contentSize.height), size: CGSize(width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight))
        loadingView = InfiniteScrollActivityView(frame: frame)
        loadingView!.isHidden = true
        tableView.addSubview(loadingView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
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
        let posts = (responseDictionary.value(forKey: "response") as? NSDictionary)?.value(forKey: "posts") as! NSArray
        self.data += (posts as? [NSDictionary])!
        self.stopIndex += self.data.count
        tableView.reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
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
            refreshControl.endRefreshing()
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = data[indexPath.row]
        let photos = (post.value(forKey: "photos") as? NSArray)?[0] as? NSDictionary
        let photo = photos?.value(forKey: "original_size") as? NSDictionary
        let imageUrl = NSURL(string: photo?["url"] as! String) as! URL
        
        cell.postImageView.setImageWith(imageUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PostDetailViewController
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        let post = data[(indexPath?.row)!]
        
        
        vc.post = post
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 1, alpha: 0.9).cgColor
        profileView.layer.borderWidth = 1
        
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        
        let label = UILabel(frame: CGRect(x: 50, y: 15, width: 240, height: 25))
        label.text = "Humans of New York"
        headerView.addSubview(label)
        
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!loading) {
            let scrollHeight = scrollView.contentOffset.y + tableView.bounds.size.height //- scrollView.contentInset.bottom
            if (scrollHeight > tableView.contentSize.height && tableView.isDragging) {
                loading = true
                let frame = CGRect(origin: CGPoint(x: 0,y: tableView.contentSize.height), size: CGSize(width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight))
                loadingView?.frame = frame
                loadingView!.startAnimating()
                getMorePosts(endpoint: self.endpoint)
            }
        }
    }
    
    func getMorePosts(endpoint: String) {
        let url = URL(string: "https://api.tumblr.com/v2/blog/\(endpoint)/posts/photo?api_key=\(self.apiKey)&offset=\(stopIndex)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.loading = false
                    self.loadingView!.stopAnimating()
                    self.successCallback(responseDictionary: responseDictionary)
                }
            }
            
        })
        task.resume()
    }
}
