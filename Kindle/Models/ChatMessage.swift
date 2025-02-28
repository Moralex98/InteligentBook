//
//  ChatMessage.swift
//  Kindle
//
//  Created by Freddy Morales on 19/02/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
}

