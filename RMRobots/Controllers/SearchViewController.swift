//
//  SearchViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 11.01.2021.
//

import UIKit

// MARK: - UIViewController
class SearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var spinner: UIActivityIndicatorView?
    
    private var isLoading = false
    private var page = 0
    private var totalPages = 0
    private var searchQuery = ""
    
    var collectionPhotos = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > collectionView.contentSize.height - scrollView.frame.size.height + 50 {
            if !isLoading {
                loadNextPage()
            }
        }
    }
    
    private func loadNextPage() {
        guard page < totalPages || totalPages == 0 else { return }
        
        isLoading = true
        self.spinner?.startAnimating()
        
        page += 1
        isLoading = true
        NetworkService.shared.searchPhotos(str: self.searchQuery, page: self.page) { (searchResult) in
            self.isLoading = false
            self.totalPages = searchResult.totalPages
            DispatchQueue.main.async {
                self.spinner?.stopAnimating()
                self.collectionPhotos.append(contentsOf: searchResult.results)
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        if let url = URL(string: collectionPhotos[indexPath.row].urls.small) {
            cell.photoImageView.loadImage(from: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView.identifier, for: indexPath) as! FooterCollectionReusableView
            
            self.spinner = footerView.spinner
            
            return footerView
        } else if kind == UICollectionView.elementKindSectionHeader {
            let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchBar", for: indexPath)

            return searchView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: PhotoViewController.identifier) as? PhotoViewController else { return }
        dvc.photo = collectionPhotos[indexPath.row]
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 2 - 4) / 3, height: (view.frame.size.width - 2 - 4) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text!.lowercased()
        page = 0
        totalPages = 0
        
        loadNextPage()
    }
}
