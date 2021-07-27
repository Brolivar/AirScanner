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

    // MARK: - Private properties

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        forecastManager.requestCurrentForecastData(requestType: .upcomingForecast) { status in
            print("STATUS: ", status)
        }
        forecastManager.requestCurrentForecastData(requestType: .currentForecast) { status in
            print("STATUS: ", status)
        }
    }

}

