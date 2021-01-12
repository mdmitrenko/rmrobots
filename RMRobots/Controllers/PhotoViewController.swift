//
//  PhotoViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 08.01.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var photoImageView: CollectionImageView!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static let identifier = "PhotoViewController"
    
    @IBAction func photoLinkClicked(_ sender: Any) {
        openUrl(urlStr: photo.urls.full)
    }
    
    var photo: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: photo.urls.regular) {
            photoImageView.loadImage(from: url)
            photoImageView.backgroundColor = UIColor(hex: photo.color)
        }
        
        widthLabel.text = "Width: \(photo.width)"
        heightLabel.text = "Height: \(photo.height)"
        descriptionTextView.text = photo.description ?? "No description"
    }
    
    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
