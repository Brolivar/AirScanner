//
//  ForecastListViewController.swift
//  AirScanner
//
//  Created by Jose Bolivar on 26/7/21.
//

import UIKit

class ForecastListViewController: UIViewController {

    // MARK: - Public Variables
    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var forecastManager: ForecastControllerProtocol! = ForecastModelController()

    // MARK: - UI properties
    @IBOutlet private var airQualityLabel: UILabel!
    @IBOutlet private var currentDateLabel: UILabel!


    // MARK: - Private properties

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestCurrentForecast()
//        forecastManager.requestCurrentForecastData(requestType: .currentForecast) { status in
//            print("STATUS: ", status)
//        }
    }


    // MARK: - Private function
    private func requestCurrentForecast() {
        forecastManager.requestForecastData(requestType: .currentForecast) { status in
            print("Current forecast request status: ", status)
            if status {
                if let currentAirForecast = self.forecastManager.getCurrentForecast() {
                    DispatchQueue.main.async {
                        print("qualit: \(currentAirForecast.getQualityIndex())")
                        self.airQualityLabel.text = currentAirForecast.getQualityIndex().description
                        self.currentDateLabel.text = self.formatForecastDate(date: currentAirForecast.getDateComponent())
                    }
                } else {
                    print("Error: No current forecast available")
                }

            }
        }
    }

    // Date formating
    private func formatForecastDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }

}

