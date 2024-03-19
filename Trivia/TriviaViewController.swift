//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        fetchTriviaQuestions()
      }
      
      private func fetchTriviaQuestions() {
        TriviaQuestionService.fetchQuestions { result in
          switch result {
          case .success(let questions):
            print("Questions fetched successfully:", questions)
            self.questions = questions
            self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
          case .failure(let error):
            print("Error fetching questions:", error)
            // Handle error: Display alert, retry fetch, etc.
          }
        }
      }

    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questionIndex < questions.count else {
            // Handle scenario when questions array is empty or index is out of bounds
            return
        }
        
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        
        // Shuffle all answer options (including correct and incorrect answers)
        let allAnswers = question.allAnswers.shuffled()
        
        // Set button titles based on the number of available answers
        for (index, answer) in allAnswers.enumerated() {
            switch index {
            case 0:
                answerButton0.setTitle(answer, for: .normal)
            case 1:
                answerButton1.setTitle(answer, for: .normal)
            case 2:
                answerButton2.setTitle(answer, for: .normal)
            case 3:
                answerButton3.setTitle(answer, for: .normal)
            default:
                break
            }
        }
        
        // Show or hide buttons based on the number of available answers
        answerButton0.isHidden = allAnswers.count < 1
        answerButton1.isHidden = allAnswers.count < 2
        answerButton2.isHidden = allAnswers.count < 3
        answerButton3.isHidden = allAnswers.count < 4
    }

    private func updateToNextQuestion(answer: String) {
        guard currQuestionIndex < questions.count else {
            // Handle scenario when questions array is empty or index is out of bounds
            return
        }
        
        // Check if the answer is correct
        let isCorrect = isCorrectAnswer(answer)
        
        // Provide feedback to the user based on correctness
        if isCorrect {
            // Provide feedback indicating that the answer is correct
            print("Correct!")
            numCorrectQuestions += 1
        } else {
            // Provide feedback indicating that the answer is incorrect
            print("Incorrect!")
            // You can also provide additional feedback if needed
        }
        
        // Increment the question index
        currQuestionIndex += 1
        
        // Check if there are more questions available
        if currQuestionIndex < questions.count {
            // Update the next question
            updateQuestion(withQuestionIndex: currQuestionIndex)
        } else {
            // If there are no more questions, show final score
            showFinalScore()
        }
    }

    private func isCorrectAnswer(_ answer: String) -> Bool {
      guard currQuestionIndex < questions.count else {
        // Handle scenario when questions array is empty or index is out of bounds
        return false
      }
      return answer == questions[currQuestionIndex].correctAnswer
    }

    private func showFinalScore() {
      let alertController = UIAlertController(title: "Game over!",
                                              message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                              preferredStyle: .alert)
      let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
        self.currQuestionIndex = 0
        self.numCorrectQuestions = 0
        self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
      }
      alertController.addAction(resetAction)
      present(alertController, animated: true, completion: nil)
    }

    
      private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
      }
      

  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
      
      
  }
}

