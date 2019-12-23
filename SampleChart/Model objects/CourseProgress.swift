//
//  CourseProgress.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

public class CourseProgress: Decodable {
    var startDate: Date?
    var endDate: Date?
    var courseMaxScore: Int
    var submittedExercises: [SubmittedExercise]
    
    private enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
        case courseMaxScore
        case submittedExercises
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let startDateString = try? container.decode(String.self, forKey: .startDate) {
            startDate = Date.date(from: startDateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        if let endDateString = try? container.decode(String.self, forKey: .endDate) {
            endDate = Date.date(from: endDateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        courseMaxScore = try container.decode(Int.self, forKey: .courseMaxScore)
        submittedExercises = (try? container.decode([SubmittedExercise].self, forKey: .submittedExercises)) ?? []
    }
}
