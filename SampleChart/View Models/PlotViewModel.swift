//
//  PlotViewModel.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 23.12.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class PlotViewModel {
    let config: MBPlotConfig
    let dataLine: PlotLineViewModel
    let line1: PlotLineViewModel
    let line2: PlotLineViewModel
    let line3: PlotLineViewModel
    
    /// Create view model from Course Progress
    /// - Parameter courseProgress: Course Progress that we use for creating View Model
    init(courseProgress: CourseProgress) {
        let startDate = courseProgress.startDate?.dayBefore
        var maxX: Double = 0
        
        let dates = courseProgress.submittedExercises.compactMap({ $0.submissionDate }).removeDuplicates().sorted()
        var dataPoints: [PlotData] = []
        if let startDate = courseProgress.startDate?.dayBefore,
            let endDate = courseProgress.endDate {
            maxX = endDate.timeIntervalSince(startDate)
            dataPoints.append((0, 0))
            var value: Double = 0
            for date in dates {
//                dataPoints.append((date.timeIntervalSince(startDate), value))
                let score = courseProgress.submittedExercises.filter({ $0.submissionDate == date }).compactMap({ $0.maxScore }).reduce(0, +)
                value = value + Double(score) / Double(courseProgress.courseMaxScore)
                dataPoints.append((date.timeIntervalSince(startDate), value))
            }
            for item in dataPoints {
                print("Date - \(item.x), Value - \(item.y)")
            }
        }
        let screenWidth = UIScreen.main.bounds.width
        var numberOfDays: Int = 8
        if screenWidth < 375 {
            // On small screens we should display only 6 dates on the graph
            numberOfDays = 6
        }
        self.config = MBPlotConfig(dateFrom: startDate, maxX: maxX, numberOfDays: numberOfDays)
        self.dataLine = PlotLineViewModel(points: dataPoints)
        self.line1 = PlotLineViewModel(points: [(0, 0), (maxX, 1)])
        self.line2 = PlotLineViewModel(points: [(0, 0.51), (maxX, 0.51)])
        self.line3 = PlotLineViewModel(points: [(0, 0.91), (maxX, 0.91)])
    }
    
    var dates: Set<NSNumber> {
        let dateValues = dataLine.points.compactMap({ $0.x }).removeDuplicates()
        return Set(dateValues.compactMap({ NSNumber(value: $0) }))
    }
    
}
