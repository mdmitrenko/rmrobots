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
    
    func getCollections(page: Int, completion: @escaping ([Collection]) -> ()) {
        guard var url = URLComponents(string: API.collections) else { return }
        
        url.queryItems = [
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        getData(from: url.url!) { (data) in
            self.decodeData(data, withType: [Collection].self, completion: completion)
        }
    }
    
    func getCollectionPhotos(collectionId: String, page: Int, completion: @escaping ([Image]) -> ()) {
        let urlString = API.collectionPhotos.replacingOccurrences(of: ":collectionId", with: "\(collectionId)")
        
        guard var url = URLComponents(string: urlString) else { return }
        
        url.queryItems = [
            URLQueryItem(name: "per_page", value: "21"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        getData(from: url.url!) { (data) in
            self.decodeData(data, withType: [Image].self, completion: completion)
        }
    }
    
    func searchPhotos(str: String, page: Int, completion: @escaping (SearchResult) -> ()) {
        guard var url = URLComponents(string: API.searchPhotos) else { return }
        
        url.queryItems = [
            URLQueryItem(name: "per_page", value: "21"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "query", value: "\(str)")
        ]
        
        getData(from: url.url!) { (data) in
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
