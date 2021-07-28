//
//  ForecastModelController.swift
//  AirScanner
//
//  Created by Jose Bolivar on 27/7/21.
//

import Foundation

// In order to organize the forecast list by day, we need to create different sections, each containing title and a list of forecasts for that day
struct DaySection {
    var title: String
    var forecasts: [ForecastProtocol]
}

protocol ForecastControllerProtocol {
    func requestForecastData(requestType: ForecastRequestType ,completion: @escaping (Bool) -> Void)
    func getCurrentForecast() -> ForecastProtocol?
    func setSelectedForecast(at indexRow: Int, indexSection: Int)
    func getSelectedForecast() -> ForecastProtocol?
    func getSectionAt(_ index: Int) -> DaySection
    func getForecastListCount() -> Int
    func forecastAt(indexSection: Int, indexRow: Int) -> ForecastProtocol?
    func getNumberOfSections() -> Int
}

// Ideally we would have 2 separates Model Controllers - one for the forecastList array, another one for each Forecast item that would be injected to "ForecastDetailsVC", but due to the low complexity of the project, and time constraints we're only implementing one

class ForecastModelController {

    // MARK: - Properties
    var currentForecast: ForecastProtocol?
    var forecastList: [ForecastProtocol] = [] //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    // 'ForecastControllerProtocol' rather of a type 'ForecastModelController'
    private var forecastSections: [DaySection] = []

    private var networkManager: NetworkControllerProtocol = NetworkManager()
    private var selectedForecastIndexRow: Int?
    private var selectedForecastIndexSection: Int?

    private let defaultLatitude = 48.13743
    private let defaultLongitude = 11.57549
}

// MARK: - ForecastControllerProtocol extension
extension ForecastModelController: ForecastControllerProtocol {

    func forecastAt(indexSection: Int, indexRow: Int) -> ForecastProtocol? {
        // Out of bounds index control
        if (indexSection < self.forecastSections.count) && (indexRow < self.forecastSections[indexSection].forecasts.count) {
            return self.forecastSections[indexSection].forecasts[indexRow]
        } else {
            print("Error: forecast index out of bounds")
            return .none
        }
    }

    func getForecastListCount() -> Int {
        return self.forecastList.count
    }

    func getCurrentForecast() -> ForecastProtocol? {
        return self.currentForecast
    }


    func setSelectedForecast(at indexRow: Int, indexSection: Int) {
        self.selectedForecastIndexSection = indexSection
        self.selectedForecastIndexRow = indexRow
    }

    func getSelectedForecast() -> ForecastProtocol? {
        if let indexRow = self.selectedForecastIndexRow, let indexSection = self.selectedForecastIndexSection {
            return self.forecastSections[indexSection].forecasts[indexRow]
        } else {
            return .none
        }
    }

    func getSectionAt(_ index: Int) -> DaySection {
        return self.forecastSections[index]
    }

    func getNumberOfSections() -> Int {
        return self.forecastSections.count
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
                    // Calculate number of sections
                    self.groupForecastsByDate()
                    completion(true)
                }
             case .failure(let error):
                print("Current forecast request failed: ", error)
                completion(false)
            }
        }
    }

    // Groups and sorts the forecast list by date.
    private func groupForecastsByDate() {
        // We get the dictionary of grouped -> date: [Forecasts]
        let groupedDictionary = self.groupedForecastByDay()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = .current
        // Now we sort it by key (date)
        let sortedDictionary = groupedDictionary.sorted(by: { $0.key < $1.key })

        // Once grouped and sorted, it is ready to be presented on the tableview
        let sections = sortedDictionary.map { DaySection(title: dateFormatter.string(from: $0.key), forecasts: $0.value) }
        self.forecastSections = sections
    }

    // Retrieve a grouped by date dictionary from our forecastList array
    private func groupedForecastByDay() -> [Date: [ForecastProtocol]] {
        let groupedDictionary: [Date: [ForecastProtocol]] = [:]
        return self.forecastList.reduce(into: groupedDictionary) { acc, cur in
            let fromattedDate = Date(timeIntervalSince1970: cur.getDateComponent())
            let components = Calendar.current.dateComponents([.year, .month, .day], from: fromattedDate)
            // We account existing or new cases
            if let date = Calendar.current.date(from: components) {
                let existing = acc[date] ?? []
                acc[date] = existing + [cur]
            }
        }
    }
}
