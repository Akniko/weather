//
//  ViewController.swift
//  Weather
//
//  Created by Akniyet on 15.08.2022.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManger.delegate   = self
        searchTextField.delegate = self
    }

    @IBAction func locationnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
   
    
}

//MARK: - UITextFieldDelegate
extension  ViewController:UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (searchTextField.text != ""){
            return true
        }
        else{
            searchTextField.placeholder = "Type something"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate
extension  ViewController: WeatherManagerDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let cityName = searchTextField.text{
            weatherManger.fetchWeather(cityName: cityName)
            
        }
        
    }
    func didUpdateWeather(_ weatherManager:WeatherManager , weather:WeatherModel){
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            print("cityname\(weather.temperatureString)")
        }
    }
    func didError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location =  locations.last{
          locationManager.stopUpdatingLocation()
           let lat = location.coordinate.latitude
           let lon = location.coordinate.longitude
           weatherManger.fetchWeather(latitude: lat, longnitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


