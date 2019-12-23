//
//  CPTMutableLineStyle+Extension.swift
//  MathBooster
//
//  Created by Strazdin, Valentin on 11.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import CorePlot

extension CPTMutableLineStyle {
    
    /// Initialize custom line style
    /// - Parameters:
    ///   - lineColor: color
    ///   - lineWidth: width
    convenience init(lineColor: UIColor, lineWidth: CGFloat) {
        self.init()
        self.lineColor = CPTColor(cgColor: lineColor.cgColor)
        self.lineWidth = lineWidth
    }
    
    /// Custom dashed line style
    /// - Parameters:
    ///   - lineColor: color
    ///   - lineWidth: width
    static func dashedLineStyle(lineColor: UIColor, lineWidth: CGFloat) -> CPTMutableLineStyle {
        let lineStyle = CPTMutableLineStyle(lineColor: lineColor, lineWidth: lineWidth)
        lineStyle.lineCap = .round
        lineStyle.dashPattern = [15, 10]
        return lineStyle
    }
}
