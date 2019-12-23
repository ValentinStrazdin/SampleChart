//
//  ViewController.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import UIKit
import CorePlot

struct PlotIdentifiers {
    static let dataLine = "Data Line"
    static let greenLine = "Green Line"
}

class ViewController: UIViewController {
    let oneDay: Int = 24 * 60 * 60
    let greenColor = UIColor(red: 153.0/255, green: 215.0/255, blue: 159.0/255, alpha: 1.0)
    let blueColor = UIColor(red: 52.0/255, green: 102.0/255, blue: 175.0/255, alpha: 1.0)
    
    var viewModel: CourseProgressViewModel?
    
    @IBOutlet weak var hostView: CPTGraphHostingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let timeZoneIdentifier = TimeZone.current.identifier
        loadCourseProgress()
        print("Time Zone - \(timeZoneIdentifier)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initPlot()
    }

    func loadCourseProgress() {
        guard let testCourseProgressUrl = Bundle.main.url(forResource:"CourseProgress", withExtension:"json"),
            let jsonData = try? Data(contentsOf: testCourseProgressUrl) else { return }
        print(String(decoding: jsonData, as: UTF8.self))
        do {
            let response = try JSONDecoder().decode(Response<CourseProgress>.self, from: jsonData)
            self.viewModel = CourseProgressViewModel(courseProgress: response.data)
        }
        catch let err
        {
            print(err.localizedDescription)
        }
    }
    
    
    func initPlot() {
        configureHost()
        configureGraph()
        configureChart()
    }
    
    func configureHost() {
        hostView.allowPinchScaling = true
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        graph.apply(CPTTheme(named: .plainWhiteTheme))
        graph.plotAreaFrame?.borderLineStyle = nil
        graph.paddingLeft = 60.0
        graph.paddingTop = 20.0
        graph.paddingRight = 20.0
        graph.paddingBottom = 60.0
        graph.plotAreaFrame?.masksToBorder = false
        hostView.hostedGraph = graph
    }
    
    func configureChart() {
        guard let viewModel = self.viewModel else { return }
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // Grid line style
        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineWidth = 1
        gridLineStyle.lineColor = CPTColor.gray().withAlphaComponent(0.75)
        gridLineStyle.dashPattern = [15, 10]
        
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.maximumFractionDigits = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.plotDateFormat
        dateFormatter.locale = Locale(identifier: Strings.apiDateFormatterLocale)
        let timeFormatter = CPTTimeFormatter(dateFormatter: dateFormatter)
        timeFormatter.referenceDate = viewModel.dateFrom

        // Axes
        guard let axisSet = graph.axisSet as? CPTXYAxisSet,
        let x = axisSet.xAxis,
        let y = axisSet.yAxis else { return }
        // X axis
//        x.labelingPolicy = .automatic
//        x.majorGridLineStyle = nil
//        x.minorGridLineStyle = nil
        x.labelFormatter = timeFormatter
        x.majorIntervalLength = NSNumber(value: oneDay * 3)
//        x.labelingPolicy = .locationsProvided
//        x.majorTickLocations = viewModel.dates
        x.orthogonalPosition = NSNumber(value: viewModel.minY)
        x.minorTicksPerInterval = 0
//        x.labelRotation = CGFloat.pi / 2
        x.visibleRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(viewModel.minX), lengthDecimal: CPTDecimalFromDouble(viewModel.maxX - viewModel.minX))
        
//        x.title = "Date"

        // Y axis
//        y.labelingPolicy = .automatic
        y.majorGridLineStyle = gridLineStyle
//        y.minorGridLineStyle = nil
        y.majorTickLength = 10
        y.labelFormatter = percentFormatter
        y.majorIntervalLength = NSNumber(value: 0.1)
        y.orthogonalPosition = NSNumber(value: viewModel.minX)
        y.minorTicksPerInterval = 0
        y.visibleRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(viewModel.minY), lengthDecimal: CPTDecimalFromDouble(viewModel.maxY - viewModel.minY))

//        y.title = "Score"

        // Green line
        let greenLinePlot = CPTScatterPlot()
        greenLinePlot.identifier = PlotIdentifiers.greenLine as NSString

        let greenLineStyle = CPTMutableLineStyle()
        greenLineStyle.lineWidth = 2
        greenLineStyle.lineColor = CPTColor(cgColor: greenColor.cgColor)
        greenLinePlot.dataLineStyle = greenLineStyle

        greenLinePlot.dataSource = self;
        graph.add(greenLinePlot)

        // Data line
        let linePlot = CPTScatterPlot()
        linePlot.identifier = PlotIdentifiers.dataLine as NSString

        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.lineWidth = 2
        blueLineStyle.lineColor = CPTColor(cgColor: blueColor.cgColor)
        linePlot.dataLineStyle = blueLineStyle

        linePlot.dataSource = self;
        graph.add(linePlot)

        // Add plot symbols
//        CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
//        symbolLineStyle.lineColor = [CPTColor blackColor];
//        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
//        plotSymbol.fill      = [CPTFill fillWithColor:[CPTColor lightGrayColor]];
//        plotSymbol.lineStyle = symbolLineStyle;
//        plotSymbol.size      = CGSizeMake(10.0, 10.0);
//        linePlot.plotSymbol  = plotSymbol;

        // Set up plot space
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(viewModel.minX), lengthDecimal: CPTDecimalFromDouble(viewModel.maxX  - viewModel.minX))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(viewModel.minY), lengthDecimal: CPTDecimalFromDouble(viewModel.maxY - viewModel.minY))
    }
    
    
}

extension ViewController: CPTPlotDataSource {
    
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        guard let identifier = plot.identifier as? NSString else { return 0 }
        if identifier.isEqual(to: PlotIdentifiers.dataLine) {
            return UInt(self.viewModel?.plotDataSource.count ?? 0)
        }
        else if identifier.isEqual(to: PlotIdentifiers.greenLine) {
            return 2
        }
        else {
            return 5
        }
    }
    
    func double(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Double {
        var number: Double = .nan
        guard let identifier = plot.identifier as? NSString,
            let field = CPTScatterPlotField(rawValue: Int(fieldEnum)),
            let viewModel = self.viewModel else { return .nan }
        switch field {
        case .X:
            if identifier.isEqual(to: PlotIdentifiers.dataLine) {
                number = viewModel.plotDataSource[Int(idx)].x
            }
            else if identifier.isEqual(to: PlotIdentifiers.greenLine) {
                number = (idx == 0) ? viewModel.minX : viewModel.maxX
            }
            break
        case .Y:
            if identifier.isEqual(to: PlotIdentifiers.dataLine) {
                number = viewModel.plotDataSource[Int(idx)].y
            }
            else if identifier.isEqual(to: PlotIdentifiers.greenLine) {
                number = (idx == 0) ? viewModel.minY : viewModel.maxY
            }
            break
        default:
            break
        }
        return number
    }
    
}
