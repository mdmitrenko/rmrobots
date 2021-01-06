//
//  CollectionCoverImageView.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CollectionCoverImageView: UIImageView {
    var task: URLSessionTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let newImage = UIImage(data: data)
            else {
                print("Couldn't load image from url: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.removeSpinner()
                self.image = newImage
            }
        }
        
        task.resume()
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
