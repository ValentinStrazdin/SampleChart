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
    /// - Parameter Progress: Course Progress that we use for creating View Model
    init(progress: Progress) {
        let startDate = progress.startDate?.dayBefore
        var maxX: Double = 0
        
        let dates = progress.nodes.compactMap({ $0.date }).removeDuplicates().sorted()
        var dataPoints: [PlotData] = []
        if let startDate = progress.startDate?.dayBefore,
            let endDate = progress.endDate {
            maxX = endDate.timeIntervalSince(startDate)
            for date in dates {
                let score = progress.nodes.filter({ $0.date == date }).compactMap({ $0.value }).reduce(0, +)
                let value = Double(score) / Double(progress.maxValue)
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
        self.line1 = PlotLineViewModel(points: [(0, 0.55), (maxX, 0.55)])
        self.line2 = PlotLineViewModel(points: [(0, 0.3), (maxX, 0.3)])
        self.line3 = PlotLineViewModel(points: [(0, 0.8), (maxX, 0.8)])
    }
    
    var dates: Set<NSNumber> {
        let dateValues = dataLine.points.compactMap({ $0.x }).removeDuplicates()
        return Set(dateValues.compactMap({ NSNumber(value: $0) }))
    }
    
}
