//
//  CourseProgress.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

class CourseProgress: Decodable {
    var dateFrom: Date?
    var dateUntil: Date?
    var maxScore: Int
    var completedExercises: [CompletedExercise]
    
    private enum CodingKeys: String, CodingKey {
        case dateFrom = "date-from"
        case dateUntil = "date-until"
        case maxScore = "max-score"
        case completedExercise = "completed-exercises"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dateFromString = try? container.decode(String.self, forKey: .dateFrom) {
            dateFrom = Date.date(from: dateFromString)?.setTime(hour: 12, min: 0, sec: 0)
            print(dateFrom ?? "")
        }
        if let dateUntilString = try? container.decode(String.self, forKey: .dateUntil) {
            dateUntil = Date.date(from: dateUntilString)?.setTime(hour: 12, min: 0, sec: 0)
            print(dateUntil ?? "")
        }
        maxScore = try container.decode(Int.self, forKey: .maxScore)
        completedExercises = (try? container.decode([CompletedExercise].self, forKey: .completedExercise)) ?? []
    }
}
