//
//  ForecastDetailsViewController.swift
//  AirScanner
//
//  Created by Jose Bolivar on 28/7/21.
//

import UIKit

class ForecastDetailsViewController: UIViewController {

    // MARK: - Public properties
    static let detailSegueId = "showDetail"
    //Ideally these should be injected by a third party entity (i.e navigator, segue manager, etc...)
    // Instead of inyecting the whole object, we inyect only the protocol.
    var forecastManager: ForecastControllerProtocol?
    var isCurrentForecastSelected = false

    // MARK: - UI properties
    @IBOutlet private var carbonMonoxideLabel: UILabel!
    @IBOutlet private var nitrogenMonoxideLabel: UILabel!
    @IBOutlet private var nitrogenDioxideLabel: UILabel!
    @IBOutlet private var ozoneLabel: UILabel!
    @IBOutlet private var sulphurDioxideLabel: UILabel!
    @IBOutlet private var fineParticlesLabel: UILabel!
    @IBOutlet private var coarseParticulateLabel: UILabel!
    @IBOutlet private var ammoniaLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()

        // Differenciate if we have selected a cell (get from index) or the current Forecast
        if isCurrentForecastSelected {
            if let selectedForecast = self.forecastManager?.getCurrentForecast() {
                self.setForecastComponents(from: selectedForecast)
            }
        } else {
            if let selectedForecast = self.forecastManager?.getSelectedForecast() {
                self.setForecastComponents(from: selectedForecast)
            }
        }
    }
    
    private func setForecastComponents(from selectedForecast: ForecastProtocol) {
        let forecastComponents = selectedForecast.getForecastComponents()
        self.carbonMonoxideLabel.text = "\(forecastComponents.getCarbonMonoxide()) μg/m3"
        self.nitrogenMonoxideLabel.text = "\(forecastComponents.getNitrogenMonoxide()) μg/m3"
        self.nitrogenDioxideLabel.text = "\(forecastComponents.getNitrogenDioxide()) μg/m3"
        self.ozoneLabel.text = "\(forecastComponents.getOzone()) μg/m3"
        self.sulphurDioxideLabel.text = "\(forecastComponents.getSulphurDioxide()) μg/m3"
        self.fineParticlesLabel.text = "\(forecastComponents.getFineParticles()) μg/m3"
        self.coarseParticulateLabel.text = "\(forecastComponents.getCoarseParticulate()) μg/m3"
        self.ammoniaLabel.text = "\(forecastComponents.getAmmonia()) μg/m3"
    }

}
