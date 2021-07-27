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
// By abstracting the forecast (and forecast components) into a protocol we ensure the whole object is not shared,
// only the protocol with the functions to read or write, which is way safer.
protocol ForecastProtocol {
    func getDateComponent() -> String
    func getQualityIndex() -> AirQualityIndex
    func getForecastComponents() -> ForecastComponentsProtocol
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

protocol ForecastComponentsProtocol {
    func getCarbonMonoxide() -> Double
    func getNitrogenMonoxide() -> Double
    func getNitrogenDioxide() -> Double
    func getOzone() -> Double
    func getSulphurDioxide() -> Double
    func getFineParticles() -> Double
    func getCoarseParticulate() -> Double
    func getAmmonia() -> Double
}

// Different properties and concentrations of the air quality forecast
// We define on an struct so we can transition the API Response Model into the APP model more smoothly
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

// MARK: - ForecastProtocol Extension
extension Forecast: ForecastProtocol {
    func getDateComponent() -> String {
        return self.dateComponent
    }

    func getQualityIndex() -> AirQualityIndex {
        return self.qualityIndex
    }

    func getForecastComponents() -> ForecastComponentsProtocol {
        return self.forecastComponents
    }
}

// MARK: - ForecastComponentsProtocol Extension
extension ForecastComponents: ForecastComponentsProtocol {
    func getCarbonMonoxide() -> Double {
        return self.carbonMonoxide
    }
    func getNitrogenMonoxide() -> Double {
        return self.nitrogenMonoxide
    }
    func getNitrogenDioxide() -> Double {
        return self.nitrogenDioxide
    }
    func getOzone() -> Double {
        return self.ozone
    }
    func getSulphurDioxide() -> Double {
        return self.sulphurDioxide
    }
    func getFineParticles() -> Double {
        return self.fineParticles
    }
    func getCoarseParticulate() -> Double {
        return self.coarseParticulate
    }
    func getAmmonia() -> Double {
        return self.ammonia
    }
}
