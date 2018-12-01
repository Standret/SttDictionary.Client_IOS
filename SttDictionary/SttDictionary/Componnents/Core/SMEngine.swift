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
    func calculateInterval(statistics: WordStatisticsApiModel, type: AnswersRaw, badValue: Bool) -> Int
}

public class SM2Engine: SMEngine {

    var maxQuality: Int
    var easinessFactor: Float
    
    public init(maxQuality: Int = 5, easinessFactor: Float = 1.3) {
        self.maxQuality = maxQuality
        self.easinessFactor = easinessFactor
    }
    
    func gradeFlashcard(statistics: WordStatisticsApiModel, answer: Answer) -> WordStatisticsApiModel {
        
        let grade = converGrade(statistics: statistics, answer: answer.type, answerTime: answer.totalMiliseconds)
        let cardGrade = grade.rawValue
        
        let qualityFactor = Float(maxQuality - cardGrade)
        let newEasiness = max(easinessFactor, statistics.easiness + Float((0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))))
        
        var newInterval = statistics.interval
        var newRepetition = statistics.repetition
        if cardGrade < 3 {
            newInterval = 0
            newRepetition = 0
        }
        else if cardGrade == 3 {
            newInterval = 0
        }
        else {
            
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
                                      date: Date(),
                                      miliSecondsForReview: answer.totalMiliseconds)
        
        let nextRepetition = Calendar.current.date(byAdding: .day, value: newInterval, to: Date())!.onlyDay()
        print ("next rept in \(nextRepetition.toLocalTime()) with easieness: \(cardGrade < 3 ? statistics.easiness : newEasiness)")
        return WordStatisticsApiModel(id: statistics.id,
                                      dateCreated: statistics.dateCreated,
                                      wordId: statistics.wordId,
                                      lastAnswer: data,
                                      type: statistics.type,
                                      interval: newInterval,
                                      repetition: newRepetition,
                                      easiness: cardGrade < 3 ? statistics.easiness : newEasiness,
                                      nextRepetition: nextRepetition)
    }
    
    func calculateInterval(statistics: WordStatisticsApiModel, type: AnswersRaw, badValue: Bool) -> Int {
        
        let grade = converGrade(statistics: statistics, answer: type, answerTime: badValue ? Int.max : 0)
        let cardGrade = grade.rawValue
        
        let qualityFactor = Float(maxQuality - cardGrade)
        let newEasiness = max(easinessFactor, statistics.easiness + Float((0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))))
        var newInterval = statistics.interval
        var newRepetition = statistics.repetition
        if cardGrade < 3 {
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
        
        print ("---------\ngrade \(grade)\ncardGrade \(cardGrade)\nnew easiness: \(cardGrade < 3 ? statistics.easiness : newEasiness)\nold easiness \(statistics.easiness)")
        print("\nrepetition \(newRepetition)\ninterval \(Float(newRepetition - 1) * newEasiness)")
        return newInterval
    }

    private func converGrade(statistics: WordStatisticsApiModel, answer: AnswersRaw, answerTime: Int = 0) -> AnswersGrade {
        var type = AnswersGrade.forget
        if let lastAnswer = statistics.lastAnswer {
            
            if lastAnswer.answer.rawValue < 3 && answer != .forget {
                type = .pass
            }
            else if lastAnswer.answer == .pass && answer != .forget {
                if answer == .easy {
                    type = .perfect
                }
                else if answer == .hard {
                    type = answerTime > Constants.timeForPass ? .pass : .good
                }
            }
            else if lastAnswer.answer == .good {
                if answer == .easy {
                    type = .perfect
                }
                else if answer == .hard {
                    type = answerTime > Constants.timeForPass ? .pass : .good
                }
                else if answer == .forget {
                    type = .bad
                }
            }
            else if lastAnswer.answer == .perfect {
                if answer == .easy {
                    type = .perfect
                }
                else if answer == .hard {
                    type = answerTime > Constants.timeForPass ? .pass : .good
                }
                else if answer == .forget {
                    type = .fail
                }
            }
        }
        else {
            switch answer {
            case .easy:
                type = .perfect
            case .hard:
                type = answerTime > Constants.timeForPass ? .pass : .good
            case .forget:
                type = .forget
            }
        }
        
        return type
    }
}
