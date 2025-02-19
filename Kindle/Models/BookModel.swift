//
//  BookModel.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import Foundation

// Modelo de un libro
struct Book: Identifiable {
    let id: String
    let title: String
    let authors: String
    let description: String
    let imageURL: String
    let previewLink: String
    //let downloadLink: String
    //let previewLink: String
}
