//
//  CollectionCoverImageView.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

import UIKit

class CollectionImageView: UIImageView {
    var task: URLSessionTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        DispatchQueue.main.async {
            self.image = nil
            self.addSpinner()
        }
        
        if let task = task {
            task.cancel()
        }
        
        task = NetworkService.shared.loadImage(from: url) { (image) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.image = image
            }
        }
        
        if let task = task {
            task.resume()
        }
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
