//
//  ChartViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 29.03.21.
//

import UIKit
import Charts
import TinyConstraints


class ChartViewController: UIViewController, ChartViewDelegate {
    
    lazy var segmentedControl = UISegmentedControl (items: ["Week", "Month", "Year"])
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        chartView.noDataText = "No data now"
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.valueFormatter = YAxisValueFormatter()
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    var quote = Quote()
    var network = ChartNetworkManager()
    var chart: ModelForChart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = quote.symbol
        self.configureUI()
        
        network.getChart(ticker: quote.symbol!, to: .month)
        setData()
    }
    
//MARK: UI
    
    func configureUI() {
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        view.addSubview(segmentedControl)
        segmentedControl.bottomToTop(of: lineChartView)
        segmentedControl.width(to: view)
        segmentedControl.height(40.0)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(sender:)), for: .valueChanged)
        
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        debugPrint(entry)
    }
    
    func setData() {
        let dataSet = LineChartDataSet(entries: createChartDataArray(), label: quote.longName)
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.setColor(.white)
        dataSet.fill = Fill(color: .white)
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateChartArray)
    }
    
    @objc func segmentedValueChanged(sender: UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            network.getChart(ticker: quote.symbol!, to: .week)
            setData()
        } else if sender.selectedSegmentIndex == 1 {
            network.getChart(ticker: quote.symbol!, to: .month)
            setData()
        } else if sender.selectedSegmentIndex == 2 {
            network.getChart(ticker: quote.symbol!, to: .year)
            setData()
        }
    }
}

class YAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "$" + String(format: "%.2f", value)
    }
}
