//
//  Forecast.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

import Foundation

// When integers are used for raw values, the implicit value for each case is one more than the previous case.
enum AirQualityIndex: Int {
    case good = 1
    case fair
    case moderate
    case poor
    case veryPoor
}
// By abstracting the forecast into a protocol we ensure the whole object is not shared,
// only the protocol with the functions to read or write, which is way safer.
protocol ForecastProtocol {

}

struct Forecast {
    private var dateComponent: String
    private var qualityIndex: AirQualityIndex
    private var forecastComponents: ForecastComponents

    init(date: String, qualityIndex: AirQualityIndex, components: ForecastComponents) {
        self.dateComponent = date
        self.qualityIndex = qualityIndex
        self.forecastComponents = components
    }
}

// Different properties and concentrations of the air quality forecast
struct ForecastComponents: Codable {
    private var carbonMonoxide: Double
    private var nitrogenMonoxide: Double
    private var nitrogenDioxide: Double
    private var ozone: Double
    private var sulphurDioxide: Double
    private var fineParticles: Double
    private var coarseParticulate: Double
    private var ammonia: Double
    enum CodingKeys: String, CodingKey {
        case carbonMonoxide = "co"
        case nitrogenMonoxide = "no"
        case nitrogenDioxide = "no2"
        case ozone = "o3"
        case sulphurDioxide = "so2"
        case fineParticles = "pm2_5"
        case coarseParticulate = "pm10"
        case ammonia = "nh3"
    }
}

// MARK: - PugProtocol Extension
extension Forecast: ForecastProtocol {

}

