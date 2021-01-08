//
//  Image.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 18.12.2020.
//

struct Image: Codable {
    let id: String
    let description: String?
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
