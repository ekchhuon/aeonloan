//
//  LanuchViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//

import Foundation
import UIKit.UIImage

// A general rule of thumb is to never import UIKit in your view models.
// You make it public in order for it to be accessible for testing.
public class WeatherViewModel {
  private static let defaultAddress = "Phnom Penh"
  //private let geocoder = LocationGeocoder()
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter
  }()
  
  private let tempFormatter: NumberFormatter = {
    let tempFormatter = NumberFormatter()
    tempFormatter.numberStyle = .none
    return tempFormatter
  }()
  
  let locationName = Box("Loading...")
  let date = Box(" ")
  let icon: Box<UIImage?> = Box(nil)  //no image initially
  let summary = Box(" ")
  let forecastSummary = Box(" ")


  
  init() {
    //changeLocation(to: Self.defaultAddress)
  }
  
//  func changeLocation(to newLocation: String) {
//    
//    print(newLocation)
//    
//    locationName.value = "Loading..."
//    geocoder.geocode(addressString: newLocation) { [weak self] locations in
//      guard let self = self else { return }
//      if let location = locations.first {
//        self.locationName.value = location.name
//        self.fetchWeatherForLocation(location)
//        return
//      }
//      self.locationName.value = "Not found"
//      self.date.value = ""
//      self.icon.value = nil
//      self.summary.value = ""
//      self.forecastSummary.value = ""
//    }
//  }
  
//  private func fetchWeatherForLocation(_ location: Location) {
//    WeatherbitService.weatherDataForLocation(
//      latitude: location.latitude,
//      longitude: location.longitude) { [weak self] (weatherData, error) in
//        guard
//          let self = self,
//          let weatherData = weatherData
//          else {
//            return
//          }
//      // The code updates date whenever the weather data arrives.
//      self.date.value = self.dateFormatter.string(from: weatherData.date)
//      self.icon.value = UIImage(named: weatherData.iconName)
//      let temp = self.tempFormatter
//        .string(from: weatherData.currentTemp as NSNumber) ?? ""
//      self.summary.value = "\(weatherData.description) - \(temp)℉"
//      self.forecastSummary.value = "\nSummary: \(weatherData.description)"
//    }
//  }

}
