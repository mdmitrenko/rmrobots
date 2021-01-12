//
//  NetworkService.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 18.12.2020.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    func getData(from url: URL, completion: @escaping (Data) -> ()) {
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.addValue(Environment.apiAuth!, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    func decodeData<T>(_ data: Data, withType: T.Type, completion: (T) -> ()) where T : Decodable {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(T.self, from: data)
            
            completion(result)
        } catch {
            print(error)
        }
    }
    
    func getRandomImage(completion: @escaping (Image) -> ()) {
        guard  let url = URL(string: API.randomPhoto) else { return }
        
        getData(from: url) { (data) in
            self.decodeData(data, withType: Image.self, completion: completion)
        }
    }
    
    func getCollections(completion: @escaping ([Collection]) -> ()) {
        guard let url = URL(string: API.collections) else { return }
        
        getData(from: url) { (data) in
            self.decodeData(data, withType: [Collection].self, completion: completion)
        }
    }
    
    func getCollectionPhotos(collectionId: String, completion: @escaping ([Image]) -> ()) {
        let urlString = API.collectionPhotos.replacingOccurrences(of: ":collectionId", with: "\(collectionId)")
        
        guard let url = URL(string: urlString) else { return }
        
        getData(from: url) { (data) in
            self.decodeData(data, withType: [Image].self, completion: completion)
        }
    }
    
    func searchPhotos(str: String, completion: @escaping (SearchResult) -> ()) {
        let urlString = API.searchPhotos + "?query=\(str)"
        
        guard let url = URL(string: urlString) else { return }
        
        getData(from: url) { (data) in
            self.decodeData(data, withType: SearchResult.self, completion: completion)
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> ()) -> URLSessionTask? {
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(imageFromCache)
            return nil
        }
        
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let newImage = UIImage(data: data)
            else {
                print("Couldn't load image from url: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
           
            completion(newImage)
        }
    }
}
