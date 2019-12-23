//
//  Progress.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

public class Progress: Decodable {
    var startDate: Date?
    var endDate: Date?
    var maxValue: Int
    var nodes: [Node]
    
    private enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
        case maxValue
        case Nodes
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let startDateString = try? container.decode(String.self, forKey: .startDate) {
            startDate = Date.date(from: startDateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        if let endDateString = try? container.decode(String.self, forKey: .endDate) {
            endDate = Date.date(from: endDateString)?.setTime(hour: 12, min: 0, sec: 0)
        }
        maxValue = try container.decode(Int.self, forKey: .maxValue)
        nodes = (try? container.decode([Node].self, forKey: .Nodes)) ?? []
    }
}
