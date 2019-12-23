//
//  ViewController.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import UIKit
import CorePlot

class ViewController: UIViewController {
    
    var viewModel: PlotViewModel?
    
    @IBOutlet weak var hostView: CPTGraphHostingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initPlot()
    }

    func loadProgress() {
        guard let testProgressUrl = Bundle.main.url(forResource:"Progress", withExtension:"json"),
            let jsonData = try? Data(contentsOf: testProgressUrl) else { return }
        print(String(decoding: jsonData, as: UTF8.self))
        do {
            let response = try JSONDecoder().decode(Response<Progress>.self, from: jsonData)
            self.viewModel = PlotViewModel(progress: response.data)
        }
        catch let err
        {
            print(err.localizedDescription)
        }
    }
   
}


extension ViewController {
    
    // MARK: - Work with Plot
    func initPlot() {
        guard let plotViewModel = self.viewModel else { return }
        hostView.allowPinchScaling = false
        let graph = CPTXYGraph(frame: hostView.bounds)
        let theme = MBPlotTheme(config: plotViewModel.config)
        graph.apply(theme)
        // Plotting red line 51% on graph
        let line2Plot = CPTScatterPlot()
        line2Plot.dataLineStyle = CPTMutableLineStyle.dashedLineStyle(lineColor: .red, lineWidth: 1)
        line2Plot.dataSource = plotViewModel.line2
        graph.add(line2Plot)
        // Plotting green line 91% on graph
        let line3Plot = CPTScatterPlot()
        line3Plot.dataLineStyle = CPTMutableLineStyle.dashedLineStyle(lineColor: .green, lineWidth: 1)
        line3Plot.dataSource = plotViewModel.line3
        graph.add(line3Plot)
        // Plotting ideal green line on graph
        let line1Plot = CPTScatterPlot()
        line1Plot.dataLineStyle = CPTMutableLineStyle(lineColor: .green, lineWidth: 2)
        line1Plot.dataSource = plotViewModel.line1
        graph.add(line1Plot)
        // Plotting data line on graph
        let dataLinePlot = CPTScatterPlot()
        dataLinePlot.dataLineStyle = CPTMutableLineStyle(lineColor: .blue, lineWidth: 2)
        dataLinePlot.dataSource = plotViewModel.dataLine
        graph.add(dataLinePlot)
        
        if let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace {
            let config = plotViewModel.config
            plotSpace.xRange = config.xRange
            plotSpace.yRange = config.yRange
        }
        hostView.hostedGraph = graph
    }
    
}
