//
//  CollectionViewController.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 07.01.2021.
//

import UIKit

// MARK: - UIViewController
class CollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collection: Collection!
    var collectionPhotos = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        NetworkService.shared.getCollectionPhotos(collectionId: collection.id) { [weak self] (photos) in
            DispatchQueue.main.async {
                self?.collectionPhotos = photos
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: PhotoViewController.identifier) as? PhotoViewController else { return }
        dvc.photo = collectionPhotos[indexPath.row]
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
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
