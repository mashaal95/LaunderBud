//
//  DarkSkyApiClient.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
import Foundation

class DarkSkyApiClient {
    
    fileprivate let darkSkyApiKey = "8808944ad2a7b4ed23c378de927db3aa"
    
    lazy var baseUrl: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/")!
    }()
    
    let downloader = JSONDownloader()
    
    typealias WeatherCompletionHandler = (Weather?, DarkSkyError?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    private func getWeather(at coordinate: Coordinate, completionHandler completion: @escaping WeatherCompletionHandler) {
        
        guard let url = URL(string: coordinate.description, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async{
                
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let weather = Weather(json: json) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                
                completion(weather, nil)
                
            }
        }
        
        task.resume()
        
    }
    
    
    
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        
        getWeather(at: coordinate) { weather, error in
            completion(weather?.currently, error)
        }
    }
}
