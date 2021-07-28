//
//  NetworkManager.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

import Foundation

protocol NetworkControllerProtocol: AnyObject {
    func downloadForecastData(requestType: ForecastRequestType, latitude: Double, longitude: Double, completion: @escaping (Result<[Forecast], NetworkError>) -> Void)
}

// Error tracking for the API request:
// On a real scenario, more errors would be used/added, for better accuracy tracking
enum NetworkError: Error {
    case requestError
    case timeoutError
    case decodingError
}

// As the API response is basically the same for current air pollution and
// upcoming forecasts, we can use the same function for both, just changing the request URL slightly
enum ForecastRequestType {
    case currentForecast
    case upcomingForecast
}

class NetworkManager {}

extension NetworkManager: NetworkControllerProtocol {

    // Add enum to divide download forecasts or current data
    func downloadForecastData(requestType: ForecastRequestType, latitude: Double, longitude: Double, completion: @escaping (Result<[Forecast], NetworkError>) -> Void) {
        var forecastList: [Forecast] = []     // Retrieved forecast air pollution data
        var forecastURL: URL?

        if requestType == .currentForecast {
            forecastURL = URL(string: AppURL.base + AppURL.Api.airPollution + AppURL.Api.latitude + (String(latitude)) + AppURL.Api.longitude + (String(longitude)) + AppURL.Api.apiKey)
        } else if requestType == .upcomingForecast {
            forecastURL = URL(string: AppURL.base + AppURL.Api.airPollution + AppURL.Api.forecastData + AppURL.Api.latitude + (String(latitude)) + AppURL.Api.longitude + (String(longitude)) + AppURL.Api.apiKey)
        }

        if let currentForecastURL = forecastURL {
            // Convert into function
            URLSession.shared.dataTask(with: currentForecastURL, completionHandler: { (data, response, error) in
                do {
                    guard let responseData = data else {
                        completion(.failure(.requestError))
                        return
                    }
                    let response: APIForecastListResponse = try JSONDecoder().decode(APIForecastListResponse.self, from: responseData)

                    // For each forecast element, we move on from the API Model to the APP Model
                    if let forecastsResponse = response.list {
                        forecastsResponse.forEach() {
                            if let qualityIndex: AirQualityIndex = AirQualityIndex(rawValue: $0.airQualityIndex.airQuality) {
                                let date = $0.date
                                let forecastComponents = $0.components
                                let newForecast = Forecast(date: date, qualityIndex: qualityIndex, components: forecastComponents)
                                forecastList.append(newForecast)
                            }
                        }
                        if !forecastList.isEmpty {
                            completion(.success(forecastList))
                        } else {
                            completion(.failure(.decodingError))
                        }
                    } else {
                        completion(.failure(.requestError))
                    }
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            }).resume()
        }
    }

}
