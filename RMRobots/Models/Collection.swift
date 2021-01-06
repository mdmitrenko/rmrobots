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
    let coverPhoto: CoverPhoto
    
    
    enum CodingKeys: String, CodingKey {
        case totalPhotos = "total_photos"
        case coverPhoto = "cover_photo"
        case id, title
    }
}

struct CoverPhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let urls: Urls
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
