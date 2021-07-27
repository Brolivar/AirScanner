//
//  ApiResponses.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

// Here we store the "intermediate" model received from the API response
// before integrating it into our actual app model

import Foundation

struct APIForecastListResponse: Codable {
    let list: [APIForecastResponse]?

    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct APIForecastResponse: Codable {
    let airQualityIndex: APIAirQualityResponse
    let components: ForecastComponents
    let date: Int

    enum CodingKeys: String, CodingKey {
        case airQualityIndex = "main"
        case components = "components"
        case date = "dt"
    }
}

struct APIAirQualityResponse: Codable {
    let airQuality: Int
    enum CodingKeys: String, CodingKey {
        case airQuality = "aqi"
    }
}

