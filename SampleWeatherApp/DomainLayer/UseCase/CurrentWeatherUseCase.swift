//
//  CurrentWeatherUseCase.swift
//  SampleWeatherApp
//
//  Created by Anđela Šćepović on 2.4.23..
//

import Foundation
import Combine


protocol CurrentWeatherUseCase{
    func fetchCurrentWeather() -> AnyPublisher<CurrentWeatherResponse, Error>
}

struct CurrentWeatherResponse{
    let currentTemperature: Int
    let currentWeatherDescription: String
    let currentWind: Double
    let currentWindDirection: Int
    let chanceOfRain: Int
    let pressure: Int
    let humidity: Int
}

