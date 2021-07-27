//
//  AirScannerTests.swift
//  AirScannerTests
//
//  Created by Jose Bolivar on 26/7/21.
//

import XCTest
@testable import AirScanner

class AirScannerTests: XCTestCase {

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

    // Test that the Codable parser is able to decode the json format into a Forecast object
     func testStoryCodable() {
        // properties to match
        let airQualityIndex = 1
        let co = 175.24
        let no = 0
        let no2 = 0.37
        let o3 = 28.61
        let so2 = 0.05
        let pm2_5 = 0.87
        let pm10 = 0.91
        let nh3 = 0.28
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "Forecast", withExtension: "json") else {
            XCTFail("Missing File: Forecast.json")
            return
        }
        do {
            let responseData = try Data(contentsOf: url)
            let forecastResponse = try JSONDecoder().decode(APIForecastListResponse.self, from: responseData)

            if let forecastListResponse = forecastResponse.list?.first {
                XCTAssertEqual(forecastListResponse.airQualityIndex.airQuality, airQualityIndex)
                XCTAssertEqual(forecastListResponse.components.getCarbonMonoxide(), co)
                XCTAssertEqual(forecastListResponse.components.getNitrogenMonoxide(), Double(no))
                XCTAssertEqual(forecastListResponse.components.getNitrogenDioxide(), no2)
                XCTAssertEqual(forecastListResponse.components.getOzone(), o3)
                XCTAssertEqual(forecastListResponse.components.getSulphurDioxide(), so2)
                XCTAssertEqual(forecastListResponse.components.getFineParticles(), pm2_5)
                XCTAssertEqual(forecastListResponse.components.getCoarseParticulate(), pm10)
                XCTAssertEqual(forecastListResponse.components.getAmmonia(), nh3)
            } else {
                XCTFail("\nError decoding results")
            }
        } catch {
            XCTFail("\nError decoding Forecast json into object: \(error)\n")
        }
     }
}
