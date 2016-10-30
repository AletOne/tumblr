//
//  InfiniteScrollActivityView.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/29/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIActivityIndicatorView {

    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight: CGFloat = 50.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    override func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    override func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }

}
