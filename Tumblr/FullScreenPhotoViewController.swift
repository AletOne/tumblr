//
//  FullScreenPhotoViewController.swift
//  Tumblr
//
//  Created by Andrew Tsao on 10/29/16.
//  Copyright © 2016 Andrew Tsao. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    var photo: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        photoView.image = photo
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }


    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
