//
//  CollectionsViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

import UIKit

class CollectionsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var collections = [Collection]()
    
    override func viewDidLoad() {
        NetworkService.shared.getCollections { [weak self] (collections) in
            DispatchQueue.main.async {
                self?.collections = collections
                self?.tableView.reloadData()
            }
        }
    }
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
        cell.titleLabel?.text = collections[indexPath.row].title
        cell.photoCountLabel?.text = "Photos: \(collections[indexPath.row].totalPhotos)"
        if let url = URL(string: collections[indexPath.row].coverPhoto.urls.thumb) {
            cell.coverImageView.loadImage(from: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
