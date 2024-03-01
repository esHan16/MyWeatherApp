//
//  MWAHomeScreenVC.swift
//  MyWeatherApp
//
//  Created by Eshan Verma on 25/08/23.
//

import UIKit

class MWAHomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cityName: String = ""
    var weatherDataArray: [String] = []
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isLoadingData = false
    @IBOutlet weak var weatherDetailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.backgroundColor: UIColor.clear
        ]
        
        self.navigationItem.title = cityName
        weatherDetailsTableView.delegate = self
        weatherDetailsTableView.dataSource = self
        weatherDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        var weatherData = [String: Any]()
        let urlString = "https://api.weatherapi.com/v1/current.json?key=65a7aea3e395474187a20653220504&q=\(String(describing: cityName))&aqi=yes".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            self.showActivityIndicator()
            guard let data = data, error == nil else { return }
            do {
                weatherData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                guard let location = weatherData["location"] as? [String: Any] else {
                    return
                }
                self.weatherDataArray.append("City : \(location["name"] ?? "")")
                self.weatherDataArray.append("Region : \(location["region"] ?? "")")
                guard let currentWeather = weatherData["current"] as? [String: Any] else {
                    return
                }
                self.weatherDataArray.append("Temperature (°C/ °F) : \(String(format: "%.2f", (currentWeather["temp_c"] as? Double)!)) °C / \(String(format: "%.2f", (currentWeather["temp_f"] as? Double)!)) °F")
                self.weatherDataArray.append("Wind Speed (mph/ kph) : \(String(format: "%.2f", (currentWeather["wind_mph"] as? Double)!)) mph / \(String(format: "%.2f", (currentWeather["wind_kph"] as? Double)!)) kph")
                self.weatherDataArray.append("Wind : \(currentWeather["wind_degree"] ?? "") \(currentWeather["wind_dir"] ?? "")")
                self.weatherDataArray.append("Pressure : \(currentWeather["pressure_mb"] ?? "") mb / \(currentWeather["pressure_in"] ?? "") in")
                self.weatherDataArray.append("Precipitation : \(currentWeather["precip_mm"] ?? "") mm / \(currentWeather["precip_in"] ?? "") in")
                self.weatherDataArray.append("Humidity : \(currentWeather["humidity"] ?? "")%")
                self.weatherDataArray.append("Cloud cover : \(currentWeather["cloud"] ?? "")%")
                self.weatherDataArray.append("UV (Index) : \(currentWeather["uv"] ?? "")")
                self.weatherDataArray.append("AIR QUALITY")
                guard let airQualityData = currentWeather["air_quality"] as? [String: Any] else {
                    return
                }
                self.weatherDataArray.append("Carbon Monoxide : \(String(format: "%.2f", (airQualityData["co"] as? Double)!)) µg/m\u{00B3}")
                self.weatherDataArray.append("Nitrogen dioxide : \(String(format: "%.2f", (airQualityData["no2"] as? Double)!)) µg/m\u{00B3}")
                self.weatherDataArray.append("Ozone : \(String(format: "%.2f", (airQualityData["o3"] as? Double)!)) µg/m\u{00B3}")
                self.weatherDataArray.append("Sulphur dioxide : \(String(format: "%.2f", (airQualityData["so2"] as? Double)!)) µg/m\u{00B3}")
                self.weatherDataArray.append("PM2.5 : \(String(format: "%.2f", (airQualityData["pm2_5"] as? Double)!)) µg/m\u{00B3}")
                self.weatherDataArray.append("PM10 : \(String(format: "%.2f", (airQualityData["pm10"] as? Double)!)) µg/m\u{00B3}")
                var usEPAStandard : String = ""
                if(airQualityData["us-epa-index"] as! Int == 1){
                    usEPAStandard = "Good"
                } else if(airQualityData["us-epa-index"] as! Int == 2) {
                    usEPAStandard = "Moderate"
                } else if(airQualityData["us-epa-index"] as! Int == 3) {
                    usEPAStandard = "Unhealthy for sensitive group"
                } else if(airQualityData["us-epa-index"] as! Int == 4) {
                    usEPAStandard = "Unhealthy"
                } else if(airQualityData["us-epa-index"] as! Int == 5) {
                    usEPAStandard = "Very Unhealthy"
                } else if(airQualityData["us-epa-index"] as! Int == 5) {
                    usEPAStandard = "Hazardous"
                }
                self.weatherDataArray.append("US - EPA standard : \(usEPAStandard)")
                var ukDefraIndex : String = ""
                let ukDefraIndexIntegerValue = airQualityData["gb-defra-index"] as! Int
                if(ukDefraIndexIntegerValue <= 3){
                    ukDefraIndex = "Low"
                } else if(ukDefraIndexIntegerValue > 3 && ukDefraIndexIntegerValue <= 6){
                    ukDefraIndex = "Moderate"
                } else if(ukDefraIndexIntegerValue > 6 && ukDefraIndexIntegerValue <= 9){
                    ukDefraIndex = "High"
                } else {
                    ukDefraIndex = "Very High"
                }
                self.weatherDataArray.append("UK Defra Index : \(ukDefraIndex)")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.weatherDetailsTableView.reloadData()
                }
                //                DispatchQueue.main.async {
                //                    self.weatherDetailsTableView.reloadData()
                //                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = weatherDataArray[indexPath.row]
        if(weatherDataArray[indexPath.row].elementsEqual("AIR QUALITY")){
            cell.textLabel?.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 16.0)
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.systemGray2
        } else {
            cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 16.0)
            cell.textLabel?.textAlignment = .left
            cell.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func showActivityIndicator() {
        isLoadingData = true
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.weatherDetailsTableView.isUserInteractionEnabled = false
        }
    }
    
    func hideActivityIndicator() {
        isLoadingData = false
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.weatherDetailsTableView.isUserInteractionEnabled = true
        }
    }
}

struct WeatherData: Decodable {
    let code: Int
    let day: String
    let night: String
    let icon: Int
}

// Define the JSON data as a Swift array of dictionaries
let jsonData = """
[
    {
        "code" : 1000,
        "day" : "Sunny",
        "night" : "Clear",
        "icon" : 113
    },
    {
        "code" : 1003,
        "day" : "Partly cloudy",
        "night" : "Partly cloudy",
        "icon" : 116
    },
    {
        "code" : 1006,
        "day" : "Cloudy",
        "night" : "Cloudy",
        "icon" : 119
    },
    {
        "code" : 1009,
        "day" : "Overcast",
        "night" : "Overcast",
        "icon" : 122
    },
    {
        "code" : 1030,
        "day" : "Mist",
        "night" : "Mist",
        "icon" : 143
    },
    {
        "code" : 1063,
        "day" : "Patchy rain possible",
        "night" : "Patchy rain possible",
        "icon" : 176
    },
    {
        "code" : 1066,
        "day" : "Patchy snow possible",
        "night" : "Patchy snow possible",
        "icon" : 179
    },
    {
        "code" : 1069,
        "day" : "Patchy sleet possible",
        "night" : "Patchy sleet possible",
        "icon" : 182
    },
    {
        "code" : 1072,
        "day" : "Patchy freezing drizzle possible",
        "night" : "Patchy freezing drizzle possible",
        "icon" : 185
    },
    {
        "code" : 1087,
        "day" : "Thundery outbreaks possible",
        "night" : "Thundery outbreaks possible",
        "icon" : 200
    },
    {
        "code" : 1114,
        "day" : "Blowing snow",
        "night" : "Blowing snow",
        "icon" : 227
    },
    {
        "code" : 1117,
        "day" : "Blizzard",
        "night" : "Blizzard",
        "icon" : 230
    },
    {
        "code" : 1135,
        "day" : "Fog",
        "night" : "Fog",
        "icon" : 248
    },
    {
        "code" : 1147,
        "day" : "Freezing fog",
        "night" : "Freezing fog",
        "icon" : 260
    },
    {
        "code" : 1150,
        "day" : "Patchy light drizzle",
        "night" : "Patchy light drizzle",
        "icon" : 263
    },
    {
        "code" : 1153,
        "day" : "Light drizzle",
        "night" : "Light drizzle",
        "icon" : 266
    },
    {
        "code" : 1168,
        "day" : "Freezing drizzle",
        "night" : "Freezing drizzle",
        "icon" : 281
    },
    {
        "code" : 1171,
        "day" : "Heavy freezing drizzle",
        "night" : "Heavy freezing drizzle",
        "icon" : 284
    },
    {
        "code" : 1180,
        "day" : "Patchy light rain",
        "night" : "Patchy light rain",
        "icon" : 293
    },
    {
        "code" : 1183,
        "day" : "Light rain",
        "night" : "Light rain",
        "icon" : 296
    },
    {
        "code" : 1186,
        "day" : "Moderate rain at times",
        "night" : "Moderate rain at times",
        "icon" : 299
    },
    {
        "code" : 1189,
        "day" : "Moderate rain",
        "night" : "Moderate rain",
        "icon" : 302
    },
    {
        "code" : 1192,
        "day" : "Heavy rain at times",
        "night" : "Heavy rain at times",
        "icon" : 305
    },
    {
        "code" : 1195,
        "day" : "Heavy rain",
        "night" : "Heavy rain",
        "icon" : 308
    },
    {
        "code" : 1198,
        "day" : "Light freezing rain",
        "night" : "Light freezing rain",
        "icon" : 311
    },
    {
        "code" : 1201,
        "day" : "Moderate or heavy freezing rain",
        "night" : "Moderate or heavy freezing rain",
        "icon" : 314
    },
    {
        "code" : 1204,
        "day" : "Light sleet",
        "night" : "Light sleet",
        "icon" : 317
    },
    {
        "code" : 1207,
        "day" : "Moderate or heavy sleet",
        "night" : "Moderate or heavy sleet",
        "icon" : 320
    },
    {
        "code" : 1210,
        "day" : "Patchy light snow",
        "night" : "Patchy light snow",
        "icon" : 323
    },
    {
        "code" : 1213,
        "day" : "Light snow",
        "night" : "Light snow",
        "icon" : 326
    },
    {
        "code" : 1216,
        "day" : "Patchy moderate snow",
        "night" : "Patchy moderate snow",
        "icon" : 329
    },
    {
        "code" : 1219,
        "day" : "Moderate snow",
        "night" : "Moderate snow",
        "icon" : 332
    },
    {
        "code" : 1222,
        "day" : "Patchy heavy snow",
        "night" : "Patchy heavy snow",
        "icon" : 335
    },
    {
        "code" : 1225,
        "day" : "Heavy snow",
        "night" : "Heavy snow",
        "icon" : 338
    },
    {
        "code" : 1237,
        "day" : "Ice pellets",
        "night" : "Ice pellets",
        "icon" : 350
    },
    {
        "code" : 1240,
        "day" : "Light rain shower",
        "night" : "Light rain shower",
        "icon" : 353
    },
    {
        "code" : 1243,
        "day" : "Moderate or heavy rain shower",
        "night" : "Moderate or heavy rain shower",
        "icon" : 356
    },
    {
        "code" : 1246,
        "day" : "Torrential rain shower",
        "night" : "Torrential rain shower",
        "icon" : 359
    },
    {
        "code" : 1249,
        "day" : "Light sleet showers",
        "night" : "Light sleet showers",
        "icon" : 362
    },
    {
        "code" : 1252,
        "day" : "Moderate or heavy sleet showers",
        "night" : "Moderate or heavy sleet showers",
        "icon" : 365
    },
    {
        "code" : 1255,
        "day" : "Light snow showers",
        "night" : "Light snow showers",
        "icon" : 368
    },
    {
        "code" : 1258,
        "day" : "Moderate or heavy snow showers",
        "night" : "Moderate or heavy snow showers",
        "icon" : 371
    },
    {
        "code" : 1261,
        "day" : "Light showers of ice pellets",
        "night" : "Light showers of ice pellets",
        "icon" : 374
    },
    {
        "code" : 1264,
        "day" : "Moderate or heavy showers of ice pellets",
        "night" : "Moderate or heavy showers of ice pellets",
        "icon" : 377
    },
    {
        "code" : 1273,
        "day" : "Patchy light rain with thunder",
        "night" : "Patchy light rain with thunder",
        "icon" : 386
    },
    {
        "code" : 1276,
        "day" : "Moderate or heavy rain with thunder",
        "night" : "Moderate or heavy rain with thunder",
        "icon" : 389
    },
    {
        "code" : 1279,
        "day" : "Patchy light snow with thunder",
        "night" : "Patchy light snow with thunder",
        "icon" : 392
    },
    {
        "code" : 1282,
        "day" : "Moderate or heavy snow with thunder",
        "night" : "Moderate or heavy snow with thunder",
        "icon" : 395
    }
]
""".data(using: .utf8)!
