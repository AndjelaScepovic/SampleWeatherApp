//
//  APIRequest.swift
//  SampleWeatherApp
//
//  Created by Anđela Šćepović on 26.3.23..
//

import Foundation

struct APIRequest{
    let API_KEY = "478cab77b100eb7c4f66a10be9d7896b"
    var baseURL: String = "https://api.openweathermap.org/data"
    let endpoint: Endpoint
    
    func getURLRequest() throws -> URLRequest{
        let url = baseURL + "/" + endpoint.serverVersion + "/" + endpoint.path + "/" + endpoint.parametars + "&appid=\(API_KEY)"
        
        guard let url = URL (string: url) else {
            throw URLError.urlMalformed
        }
        return URLRequest(url: url)
    }
}

enum Endpoint{
    
    case currentWeather(Double, Double)
    case hourlyWeather
    case weeklyWeather
    
    var serverVersion: String{
        "2.5"
    }
    
    var path: String {
        switch self{
        case .currentWeather:
            return "weather"
        case .hourlyWeather:
            return ""
        case .weeklyWeather:
            return ""
        }
        
    }
    
    var parametars: String{
        switch self{
        case .currentWeather(let latitude, let longitude):
            return "?lat=\(latitude)&lon=\(longitude)"
        case .hourlyWeather:
            return ""
        case .weeklyWeather:
            return ""
        }
    }
}

enum URLError : Error{
 
    case urlMalformed
}
