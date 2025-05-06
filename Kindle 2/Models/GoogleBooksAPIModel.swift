//
//  GoogleBooksModel.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import Foundation

struct GoogleBooksResponse: Codable {
    let items: [BookItem]
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let previewLink: String?
}

struct ImageLinks: Codable {
    let thumbnail: String
}
