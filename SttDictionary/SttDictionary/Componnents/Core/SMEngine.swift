//
//  SuperMemo.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol SMEngine {
    //func gradeFlashcard(statistics: RealmStatistics, answer: Answer) -> RealmStatistics
}

public class SM2Engine: SMEngine {

    var maxQuality: Int
    var easinessFactor: Float
    
    public init(maxQuality: Int = 5, easinessFactor: Float = 1.3) {
        self.maxQuality = maxQuality
        self.easinessFactor = easinessFactor
    }
    
//    func gradeFlashcard(statistics: RealmStatistics, answer: Answer) -> RealmStatistics {
//        let grade = converGrade(statistics: statistics, answer: answer)
//        let cardGrade = grade.rawValue
//        
//        let qualityFactor = Float(maxQuality - cardGrade)
//        let temp = max(easinessFactor, statistics.easiness + Float((0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))))
//        statistics.easiness = temp
//        
//        var interval = statistics.interval
//        if cardGrade <= 3 {
//            interval = 0
//            statistics.repetition = 0
//        } else {
//            
//            statistics.repetition += 1
//            switch statistics.repetition {
//            case 1:
//                interval = 1
//            case 2:
//                interval = 6
//            default:
//                let newInterval = ceil(Float(statistics.repetition - 1) * statistics.easiness)
//                interval = Int(newInterval)
//            }
//        }
//
//        statistics.interval = interval
//        
//        let data = RealmAnswerData()
//        data.date = Date().onlyDay()
//        data.answer = grade
//        data.miliSecondsForReview = answer.totalMiliseconds
//        statistics.answers.append(data)
//        
//        statistics.nextRepetition = Calendar.current.date(byAdding: .day, value: interval, to: Date())?.onlyDay()
//        print ("next rept in \(statistics.nextRepetition)")
//        return statistics
//    }
//    
//    private func converGrade(statistics: RealmStatistics?, answer: Answer) -> AnswersGrade {
//        var type = AnswersGrade.forget
//        if let lastAnswer = statistics?.answers.last {
//            
//            if lastAnswer.answer.rawValue < 3 && answer.type != .forget {
//                type = .pass
//            }
//            else if lastAnswer.answer == .pass && answer.type != .forget {
//                type = .good
//            }
//            else if lastAnswer.answer == .good {
//                if answer.type == .easy {
//                    type = .perfect
//                }
//                else if answer.type == .hard {
//                    type = .good
//                }
//                else if answer.type == .forget {
//                    type = .bad
//                }
//            }
//            else if lastAnswer.answer == .perfect {
//                if answer.type == .easy {
//                    type = .perfect
//                }
//                else if answer.type == .hard {
//                    type = .good
//                }
//                else if answer.type == .forget {
//                    type = .fail
//                }
//            }
//        }
//        else {
//            switch answer.type {
//            case .easy:
//                type = .perfect
//            case .hard:
//                type = .good
//            case .forget:
//                type = .forget
//            }
//        }
//        
//        return type
//    }
}
