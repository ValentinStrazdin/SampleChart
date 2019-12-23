//
//  CourseProgressViewModel.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 01.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

typealias PlotData = (x: Double, y: Double)

struct CourseProgressViewModel {
    var dateFrom: Date?
    var plotDataSource: [PlotData] = []
    var minX: Double = 0
    var maxX: Double = 0
    var minY: Double = 0
    var maxY: Double = 1
    
    init(courseProgress: CourseProgress) {
        self.dateFrom = courseProgress.dateFrom
        let dates = courseProgress.completedExercises.compactMap({ $0.date }).removeDuplicates().sorted()
        plotDataSource = []
        guard let dateFrom = courseProgress.dateFrom,
            let dateUntil = courseProgress.dateUntil else { return }
        maxX = dateUntil.timeIntervalSince(dateFrom)
        plotDataSource.append((minX, 0))
        var value: Double = 0
        for date in dates {
            plotDataSource.append((date.timeIntervalSince(dateFrom), value))
            let score = courseProgress.completedExercises.filter({ $0.date == date }).compactMap({ $0.maxScore }).reduce(0, +)
            value = value + Double(score) / Double(courseProgress.maxScore)
            plotDataSource.append((date.timeIntervalSince(dateFrom), value))
        }
        for item in plotDataSource {
            print("Date - \(item.x), Value - \(item.y)")
        }
    }
    
    var dates: Set<NSNumber> {
        let dateValues = plotDataSource.compactMap({ $0.x }).removeDuplicates()
        return Set(dateValues.compactMap({ NSNumber(value: $0) }))
    }
    
}
