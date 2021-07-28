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
    @IBOutlet private var forecastTableView: UITableView!


    // MARK: - Private properties

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestCurrentForecast()
        self.requestUpcomingForecasts()
    }


    // MARK: - Private function
    private func requestCurrentForecast() {
        forecastManager.requestForecastData(requestType: .currentForecast) { status in
            print("Current forecast request status: ", status)
            if status {
                if let currentAirForecast = self.forecastManager.getCurrentForecast() {
                    DispatchQueue.main.async {
                        self.airQualityLabel.text = currentAirForecast.getQualityIndex().description
                        self.currentDateLabel.text = self.formatForecastDate(date: currentAirForecast.getDateComponent())
                    }
                } else {
                    print("Error: No current forecast available")
                }

            }
        }
    }

    private func requestUpcomingForecasts() {
        forecastManager.requestForecastData(requestType: .upcomingForecast) { status in
            print("Upcoming forecast request status: ", status)
            DispatchQueue.main.async {
                self.forecastTableView.reloadData()
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

// MARK: - UITableViewDelegate Extension
extension ForecastListViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource Extension
extension ForecastListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ForecastTableViewCell.self), for: indexPath) as? ForecastTableViewCell
            else { return UITableViewCell() }
        let indexRow = indexPath.row
        let indexSection = indexPath.section

        if let cellForecast = forecastManager.forecastAt(indexSection: indexSection, indexRow: indexRow) {
            cell.configure(from: cellForecast)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.forecastManager.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastManager.getSectionAt(section).forecasts.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.forecastManager.getSectionAt(section).title
    }
}
