//
//  PlotLineViewModel.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 23.12.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import CorePlot

typealias PlotData = (x: Double, y: Double)

class PlotLineViewModel: NSObject {
    let points: [PlotData]
    
    init(points: [PlotData]) {
        self.points = points
    }
}

extension PlotLineViewModel: CPTPlotDataSource {
    
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.points.count)
    }
    
    func double(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Double {
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return .nan
        }
        switch field {
        case .X:
            return self.points[Int(idx)].x
        case .Y:
            return self.points[Int(idx)].y
        default:
            return .nan
        }
    }
}
