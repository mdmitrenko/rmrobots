//
//  ViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 16.12.2020.
//

import UIKit

class RandomImageViewController: UIViewController {
    @IBOutlet weak var imageView: CollectionImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        NetworkService.shared.getRandomImage() { (image) in
            DispatchQueue.main.sync {
                self.activityIndicatorView.stopAnimating()
            }
            
            if let url = URL(string: image.urls.regular) {
                self.imageView.loadImage(from: url)
            }
        }
    }
}
