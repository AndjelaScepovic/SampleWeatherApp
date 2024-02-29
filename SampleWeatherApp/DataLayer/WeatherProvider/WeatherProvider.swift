//
//  WeatherProvider.swift
//  SampleWeatherApp
//
//  Created by Anđela Šćepović on 2.4.23..
//

import Foundation
import Combine

final class WeatherProvider: CurrentWeatherUseCase{
    let webService: WebService
    
    init (webService: WebService){
        self.webService = webService
    }
    func fetchCurrentWeather() -> AnyPublisher<CurrentWeatherResponse, Error>{
        let request = APIRequest(endpoint: .currentWeather(42.4304, 19.2594))
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
            
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap {request -> AnyPublisher<CurrentWeatherDTO, Error> in
                self.webService.execute(request)
            }
            .map{dto in
                dto.currentWeatherResponse
            }
            .eraseToAnyPublisher()
    }
}

struct CurrentWeatherDTO: Decodable{
    
    let weather: [WeatherDTO]
    let main: MainDTO
    let wind: WindDTO
    let rain: RainDTO
    
    var currentWeatherResponse: CurrentWeatherResponse{
        CurrentWeatherResponse(
            currentTemperature: Int(main.maxTemperature),
            currentWeatherDescription: weather.first?.description ?? "",
            currentWind: wind.speed,
            currentWindDirection: wind.direction,
            chanceOfRain: Int(rain.chance),
            pressure: main.pressure,
            humidity: main.humidity)
    }
    
    struct RainDTO: Decodable{
        let chance: Double
        
        enum CodingKeys: String, CodingKey{
            case chance = "1h"
        }
    }
    
    struct WeatherDTO: Decodable{
        let description: String
    }
    
    struct MainDTO: Decodable{
        let temperature, minTemperature, maxTemperature: Double
        let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey{
            case pressure
            case humidity
            case temperature = "temp"
            case minTemperature = "min_temp"
            case maxTemperature = "max_temp"
        }
    }
    
    struct WindDTO: Decodable{
        let speed: Double
        let direction: Int
    }
}
