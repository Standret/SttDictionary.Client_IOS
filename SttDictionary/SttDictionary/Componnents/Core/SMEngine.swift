//
//  SuperMemo.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol SMEngine {
    func gradeFlashcard(statistics: WordStatisticsApiModel, answer: Answer) -> WordStatisticsApiModel
}

public class SM2Engine: SMEngine {

    var maxQuality: Int
    var easinessFactor: Float
    
    public init(maxQuality: Int = 5, easinessFactor: Float = 1.3) {
        self.maxQuality = maxQuality
        self.easinessFactor = easinessFactor
    }
    
    func gradeFlashcard(statistics: WordStatisticsApiModel, answer: Answer) -> WordStatisticsApiModel {
        let grade = converGrade(statistics: statistics, answer: answer)
        let cardGrade = grade.rawValue
        
        let qualityFactor = Float(maxQuality - cardGrade)
        let newEasiness = max(easinessFactor, statistics.easiness + Float((0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))))
        
        var newInterval = statistics.interval
        var newRepetition = statistics.repetition
        if cardGrade <= 3 {
            newInterval = 0
            newRepetition = 0
        } else {
            
            newRepetition += 1
            switch newRepetition {
            case 1:
                newInterval = 1
            case 2:
                newInterval = 6
            default:
                newInterval = Int(ceil(Float(newRepetition - 1) * newEasiness))
            }
        }
        
        let data = AnswerDataApiModel(answer: grade,
                                      type: statistics.type,
                                      raw: answer.type,
                                      date: Date().onlyDay(),
                                      miliSecondsForReview: answer.totalMiliseconds)
        
        let nextRepetition = Calendar.current.date(byAdding: .day, value: newInterval, to: Date())!.onlyDay()
        print ("next rept in \(nextRepetition)")
        return WordStatisticsApiModel(id: statistics.id,
                                      dateCreated: statistics.dateCreated,
                                      wordId: statistics.wordId,
                                      lastAnswer: data,
                                      type: statistics.type,
                                      interval: newInterval,
                                      repetition: newRepetition,
                                      easiness: newEasiness,
                                      nextRepetition: nextRepetition)
    }

    private func converGrade(statistics: WordStatisticsApiModel, answer: Answer) -> AnswersGrade {
        var type = AnswersGrade.forget
        if let lastAnswer = statistics.lastAnswer {
            
            if lastAnswer.answer.rawValue < 3 && answer.type != .forget {
                type = .pass
            }
            else if lastAnswer.answer == .pass && answer.type != .forget {
                type = .good
            }
            else if lastAnswer.answer == .good {
                if answer.type == .easy {
                    type = .perfect
                }
                else if answer.type == .hard {
                    type = .good
                }
                else if answer.type == .forget {
                    type = .bad
                }
            }
            else if lastAnswer.answer == .perfect {
                if answer.type == .easy {
                    type = .perfect
                }
                else if answer.type == .hard {
                    type = .good
                }
                else if answer.type == .forget {
                    type = .fail
                }
            }
        }
        else {
            switch answer.type {
            case .easy:
                type = .perfect
            case .hard:
                type = .good
            case .forget:
                type = .forget
            }
        }
        
        return type
    }
}
