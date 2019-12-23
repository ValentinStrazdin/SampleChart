//
//  SubmittedExercise.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

class SubmittedExercise: Decodable {
    var submissionDate: Date?
    var maxScore: Int
    
    private enum CodingKeys: String, CodingKey {
        case submissionDate
        case maxScore
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let submissionDateString = try? container.decode(String.self, forKey: .submissionDate) {
            // Set custom time for Budget valid from date
            submissionDate = Date.date(from: submissionDateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        maxScore = try container.decode(Int.self, forKey: .maxScore)
    }
}
