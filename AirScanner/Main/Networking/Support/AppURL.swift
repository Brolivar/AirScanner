//
//  AppURL.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

import Foundation

//http://api.openweathermap.org/data/2.5/air_pollution?lat=50&lon=50&appid=70174fd53112898ba962c46aaccb9a0f

struct AppURL {
    static let base = "https://api.openweathermap.org/data/2.5/"
    struct Api {
        static let airPollution = "air_pollution"       // Current air pollution data
        static let forecastData = "/forecast"       // Forecast air pollution data
        static let latitude = "?lat="
        static let longitude = "&lon="
        static let apiKey = "&appid=70174fd53112898ba962c46aaccb9a0f"
    }
}
