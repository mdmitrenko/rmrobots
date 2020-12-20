//
//  Image.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 18.12.2020.
//

import Foundation

struct Image {
    
    var id: String
    var width: Int
    var height: Int
    var url: String
    
    init?(json: Any) {
        guard let data = json as? AnyObject else { return nil }
        
        guard let imageId = data["id"] as? String,
              let width = data["width"] as? Int,
              let height = data["height"] as? Int,
              let urls = data["urls"] as? AnyObject,
              let url = urls["regular"] as? String else {
            return nil
        }
        
        self.id = imageId
        self.width = width
        self.height = height
        self.url = url
    }
}
