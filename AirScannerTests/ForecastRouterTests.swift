//
//  ForecastRouterTests.swift
//  AirScannerTests
//
//  Created by Jose Bolivar on 27/7/21.
//

import XCTest
@testable import AirScanner

class ForecastRouterTests: XCTestCase {

    private var forecastManager: ForecastModelController! = ForecastModelController()
    private var networkManager: NetworkControllerProtocol = NetworkManager()


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testForecastAPIReachable() {
        let ex = expectation(description: "Expecting a response from Forecast API")

        self.networkManager.downloadForecastData(requestType: .currentForecast, latitude: 50, longitude: 50) { result in
            switch result {
            case .success(_):
                print("Forecast request successfully")
                ex.fulfill()
             case .failure(let error):
                print("Forecast request failed: ", error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }

    //Test that the API returns a valid result
    func testForecastAPI() {
        let ex = expectation(description: "Expecting a success return from the api")

        self.networkManager.downloadForecastData(requestType: .currentForecast, latitude: 50, longitude: 50) { result in
            switch result {
            case .success(let forecastList):
                print("Forecast request successfully")
                if forecastList.isEmpty {
                    print("Return object is nil")
                } else {
                    ex.fulfill()
                }
             case .failure(let error):
                print("Forecast request failed: ", error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }

}
