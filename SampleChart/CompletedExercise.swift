//
//  CompletedExercise.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

class CompletedExercise: Decodable {
    var date: Date?
    var maxScore: Int
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case maxScore = "max-score"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dateString = try? container.decode(String.self, forKey: .date) {
            // Set custom time for Budget valid from date
            date = Date.date(from: dateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        maxScore = try container.decode(Int.self, forKey: .maxScore)
    }
}
