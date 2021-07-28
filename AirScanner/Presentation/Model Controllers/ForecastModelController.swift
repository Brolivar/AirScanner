//
//  ForecastModelController.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

import Foundation

protocol ForecastControllerProtocol {
    func requestForecastData(requestType: ForecastRequestType ,completion: @escaping (Bool) -> Void)
    func getCurrentForecast() -> ForecastProtocol?
}

// Ideally we would have 2 separates Model Controllers - one for the forecastList array, another one for each Forecast item that would be injected to "ForecastDetailsVC", but due to the low complexity of the project, and time constraints we're only implementing one

class ForecastModelController {

    // MARK: - Properties

    var currentForecast: ForecastProtocol?
    var forecastList: [ForecastProtocol] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    // 'ForecastControllerProtocol' rather of a type 'ForecastModelController'

    private var networkManager: NetworkControllerProtocol = NetworkManager()
    private var selectedForecast: Int?

    private let defaultLatitude = 48.13743
    private let defaultLongitude = 11.57549
}

// MARK: - ForecastControllerProtocol extension
extension ForecastModelController: ForecastControllerProtocol {

    func getCurrentForecast() -> ForecastProtocol? {
        return self.currentForecast
    }

    // Makes a request to the Network Manager to retrieve the selected forecast data
    //
    // - Parameter requestType: type of forecast data to be retrieved (current forecast request or upcoming forecast data)
    // - Returns status: final status from the request
    func requestForecastData(requestType: ForecastRequestType, completion: @escaping (Bool) -> Void) {

        self.networkManager.downloadForecastData(requestType: requestType, latitude: self.defaultLatitude, longitude: self.defaultLongitude) {  [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let forecastList):
                if requestType == .currentForecast {
                    print("Current forecast request successfully")
                    self.currentForecast = forecastList.first
                    completion(true)
                } else if requestType == .upcomingForecast {
                    print("Upcoming forecast request successfully")
                    self.forecastList = forecastList
                    completion(true)
                }
             case .failure(let error):
                print("Current forecast request failed: ", error)
                completion(false)
            }
        }
    }
}
