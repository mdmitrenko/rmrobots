//
//  NetworkService.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 18.12.2020.
//

import Foundation
import UIKit

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    func getData(url: URL, completion: @escaping (Any) -> ()) {
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.addValue(Environment.apiAuth!, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                completion(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    public func getRandomImage(completion: @escaping (Image) -> ()) {
        guard  let url = URL(string: "https://api.unsplash.com/photos/random") else {
            return
        }
        
        getData(url: url) { (json) in
            let image = Image(json: json)
            completion(image!)
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
}
