//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion]
}


struct TriviaQuestion: Decodable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let isTrueFalse: Bool? // Indicates if the question is true or false

    // Computed property to combine correct and incorrect answers for all answer choices
    var allAnswers: [String] {
        return [correctAnswer] + incorrectAnswers
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer" // Custom key mapping
        case incorrectAnswers = "incorrect_answers"
        case isTrueFalse = "isTrueFalse" // Custom key mapping for true/false questions
    }
}
