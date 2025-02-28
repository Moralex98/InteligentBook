//
//  AIService.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import Foundation
import Alamofire

class AIService {
    static func fetchAIContent(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyD-8VpdOdNXByGRlKElbhdS2ZpM8NL-iGQ"
        let parameters : [String: Any] = [
            "contents" : [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonResponse = data as? [String: Any],
                       let candidates = jsonResponse["candidates"] as? [[String: Any]],
                       let content = candidates.first?["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let text = parts.first?["text"] as? String {
                        completion(.success(text))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])))
                    }
                case .failure(let error):
                    completion(.failure(error)) // return the error if the request fais
                }
            }
    }
}
