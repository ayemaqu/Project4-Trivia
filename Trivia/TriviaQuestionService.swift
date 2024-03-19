//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Ayema Qureshi on 3/19/24.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=5") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
