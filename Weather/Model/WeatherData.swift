//
//  WeatherData.swift
//  Weather
//
//  Created by Akniyet on 15.08.2022.
//

import Foundation

struct WeatherData:Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    
    
}

struct Main: Codable{
    let temp:Double
}

struct Description:Codable {
    let description:String
}
struct Weather:Codable {
    let description:String
    let id:Int
}
