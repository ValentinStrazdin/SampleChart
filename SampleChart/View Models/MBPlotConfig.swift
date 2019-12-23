//
//  MBPlotConfig.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 23.12.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import CorePlot

/// Custom configuration for MathBooster plot
public struct MBPlotConfig {
    /// Number of seconds in one day
    let oneDay: Int = 24 * 60 * 60
    
    let dateFrom: Date?
    let maxX: Double
    /// Number of days that should be displayed on graph
    let numberOfDays: Int
    
    init(dateFrom: Date?, maxX: Double, numberOfDays: Int) {
        self.dateFrom = dateFrom
        self.maxX = maxX
        self.numberOfDays = numberOfDays
    }
    
    var xRange: CPTPlotRange {
        return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0),
                            lengthDecimal: CPTDecimalFromDouble(maxX))
    }
    
    var yRange: CPTPlotRange {
        return CPTPlotRange(locationDecimal: CPTDecimalFromDouble(0),
                            lengthDecimal: CPTDecimalFromDouble(1))
    }
    
    var xMajorIntervalLength: NSNumber {
        // Interval should not be less than one day
        let interval = max(maxX / Double(oneDay * (numberOfDays - 1)), 1)
        return NSNumber(value: Int(interval * Double(oneDay)))
    }
}

