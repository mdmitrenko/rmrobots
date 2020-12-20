//
//  ViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 16.12.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        NetworkService.shared.getRandomImage() { (response) in
            guard let url = URL(string: response.url) else { return }
            
            NetworkService.shared.loadImage(url: url) { [weak self] (image) in
                if image !== nil {
                    DispatchQueue.main.async {
                        self?.image.image = image
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }

}
