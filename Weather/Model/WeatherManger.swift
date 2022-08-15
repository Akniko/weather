//
//  WeatherManger.swift
//  Weather
//
//  Created by Akniyet on 15.08.2022.
//

import Foundation
import  CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather:WeatherModel)
    func didError(error:Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3eb9b706047f12ce2deb2d1c5b3d0de1&units=metric"
    
//https://api.weather.gov/points/39.7456,-97.0892
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        print("url\(urlString)")
    }
    
    func fetchWeather(latitude:CLLocationDegrees , longnitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longnitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String)  {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
          
            let task = session.dataTask(with: url) { data, responnse, error in
                if error != nil {
                    self.delegate?.didError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    func parseJSON(weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let tempo = decodeData.main.temp
            let cityName = decodeData.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: cityName, temperature: tempo)
            return weatherModel
        }
        catch{
            delegate?.didError(error: error)
            return nil
        }
    }
   
    
}
