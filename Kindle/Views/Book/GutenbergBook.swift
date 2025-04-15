//
//  GutenbergBook.swift
//  Kindle
//
//  Created by Freddy Morales on 07/04/25.
//

import Foundation
import SwiftUI

struct GutenberxResponse: Codable {
    let results: [GutenbergBook]
}

struct GutenbergBook: Codable, Identifiable {
    let id: Int
    let title: String
    let authors: [Author]
    let formats: [String: String]

    struct Author: Codable {
        let name: String
    }
}

