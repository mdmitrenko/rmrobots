//
//  NetworkService.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 18.12.2020.
//

import UIKit

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    func getData(url: URL, completion: @escaping (Data) -> ()) {
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.addValue(Environment.apiAuth!, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    public func getRandomImage(completion: @escaping (Image) -> ()) {
        guard  let url = URL(string: API.randomPhoto) else { return }
        
        getData(url: url) { (data) in
            let decoder = JSONDecoder()
            
            do {
                let image = try decoder.decode(Image.self, from: data)
                
                completion(image)
            } catch {
                print(error)
            }
        }
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                
                completion(image)
            }
            else {
                completion(nil)
            }
        }.resume()
    }
    
    func getCollections(completion: @escaping ([Collection]) -> ()) {
        guard let url = URL(string: API.collections) else { return }
        
        getData(url: url) { (data) in
            let decoder = JSONDecoder()
            
            do {
                let collections = try decoder.decode([Collection].self, from: data)
                
                completion(collections)
            } catch {
                print(error)
            }
        }
    }
    
    func getCollectionPhotos(collectionId: String, completion: @escaping ([Image]) -> ()) {
        let urlString = API.collectionPhotos.replacingOccurrences(of: ":collectionId", with: "\(collectionId)")
        
        guard let url = URL(string: urlString) else { return }
        
        getData(url: url) { (data) in
            let decoder = JSONDecoder()
            
            do {
                let photos = try decoder.decode([Image].self, from: data)
                
                completion(photos)
            } catch {
                print(error)
            }
        }
    }
}
