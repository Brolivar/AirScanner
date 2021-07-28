//
//  ForecastTableViewCell.swift
//  AirScanner
//
//  Created by Jose Bolivar on 28/7/21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var airQualityIndexLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(from forecast: ForecastProtocol) {
        self.dateLabel.text = formatForecastDate(date: forecast.getDateComponent())
        self.airQualityIndexLabel.text = forecast.getQualityIndex().description
        switch forecast.getQualityIndex() {
        case .good, .fair:
            self.backgroundColor = UIColor(named: "AirQualityGoodColor")
        case .moderate:
            self.backgroundColor = UIColor(named: "AirQualityModerateColor")
        case .poor, .veryPoor:
            self.backgroundColor = UIColor(named: "AirQualityPoorColor")
        }
    }

    // Reset the table cells as if it were new
    override func prepareForReuse() {
        self.resetToDetault()
    }

    private func resetToDetault() {
        self.dateLabel.text = ""
        self.airQualityIndexLabel.text = ""
        self.backgroundColor = .white
    }

    // Date formating
    private func formatForecastDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
