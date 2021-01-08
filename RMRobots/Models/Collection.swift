//
//  Collection.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 06.01.2021.
//

struct Collection: Codable {
    let id: String
    let title: String
    let totalPhotos: Int
    let coverPhoto: Image
    
    
    enum CodingKeys: String, CodingKey {
        case totalPhotos = "total_photos"
        case coverPhoto = "cover_photo"
        case id, title
    }
}
