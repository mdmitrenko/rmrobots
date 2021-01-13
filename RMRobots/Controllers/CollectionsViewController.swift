//
//  CollectionsViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

import UIKit

// MARK: - UIViewController
class CollectionsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private var isLoading = false
    private var page = 0
    
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! CollectionViewController
                dvc.collection = collections[indexPath.row]
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > tableView.contentSize.height - scrollView.frame.size.height + 50 {
            if !isLoading {
                loadNextPage()
            }
        }
    }
    
    private func loadNextPage() {
        isLoading = true
        tableView.tableFooterView = createSpinnerFooter()
        
        page += 1
        isLoading = true
        NetworkService.shared.getCollections(page: page) { [weak self] (collections) in
            self?.isLoading = false
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
                self?.collections.append(contentsOf: collections)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

// MARK: - UITableViewDataSource
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
