//
//  API.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 08.01.2021.
//

struct API {
    static let randomPhoto = "\(Environment.apiHost)/photos/random"
    static let collections = "\(Environment.apiHost)/collections"
    static let collectionPhotos = "\(Environment.apiHost)/collections/:collectionId/photos"
}
