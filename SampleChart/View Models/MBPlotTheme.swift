//
//  MBPlotTheme.swift
//  MathBooster
//
//  Created by Valentin Strazdin on 09.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import CorePlot

/// This custom plot theme
public class MBPlotTheme: CPTTheme {
    var config: MBPlotConfig?
    
    init(config: MBPlotConfig?) {
        super.init()
        self.config = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Here we customize plot background
    /// - Parameter graph: graph that we are customizing
    override public func apply(toBackground graph: CPTGraph) {
        graph.fill = CPTFill(color: CPTColor.white())
        graph.paddingLeft = 40.0
        graph.paddingTop = 20.0
        graph.paddingRight = 30.0
        graph.paddingBottom = 50.0
    }
    
    /// Here we customize plot area frame
    /// - Parameter plotAreaFrame: Plot Area that we are customizing
    override public func apply(toPlotArea plotAreaFrame: CPTPlotAreaFrame) {
        plotAreaFrame.fill = CPTFill(color: CPTColor.white())
        plotAreaFrame.borderLineStyle = .none
        plotAreaFrame.cornerRadius = 0
        plotAreaFrame.masksToBorder = false
    }
    
    /// Here we customize Plot Axis Set
    /// - Parameter axisSet: Axis Set that should be customized
    override public func apply(to axisSet: CPTAxisSet) {
        guard let xyAxisSet = axisSet as? CPTXYAxisSet,
            let config = self.config else { return }
        let majorLineStyle = CPTMutableLineStyle.dashedLineStyle(lineColor: .gray, lineWidth: 1)
        
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor(cgColor: UIColor.gray.cgColor)
        textStyle.fontSize = 12
        
        if let x = xyAxisSet.xAxis {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Strings.plotDateFormat
            dateFormatter.locale = Locale(identifier: Strings.apiDateFormatterLocale)
            let timeFormatter = CPTTimeFormatter(dateFormatter: dateFormatter)
            timeFormatter.referenceDate = config.dateFrom
            
            x.labelingPolicy          = .fixedInterval
            x.labelFormatter          = timeFormatter
            x.majorIntervalLength     = config.xMajorIntervalLength
            x.axisLineStyle           = majorLineStyle
            x.visibleRange            = config.xRange
            x.labelTextStyle          = textStyle
        }
        
        if let y = xyAxisSet.yAxis {
            let percentFormatter = NumberFormatter()
            percentFormatter.numberStyle = .percent
            percentFormatter.maximumFractionDigits = 0
            
            y.majorGridLineStyle      = majorLineStyle
            y.labelingPolicy          = .fixedInterval
            y.labelFormatter          = percentFormatter
            y.majorIntervalLength     = NSNumber(value: 0.1)
            y.axisLineStyle           = .none
            y.visibleRange            = config.yRange
            y.labelTextStyle          = textStyle
        }
    }
    
}
