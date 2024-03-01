//
//  CityViewController.swift
//  MyWeatherApp
//
//  Created by Eshan Verma on 06/09/23.
//

import UIKit

class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isLoadingData = false
    
    var cityData: [String: Any]?
    var cityArray: [String] = []
    var countryName: String?
    var countryNameArrayWithoutDuplicates: [String] = []
    var filteredArr : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTableView.delegate = self;
        cityTableView.dataSource = self;
        cityNameTextField.delegate = self;
        cityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.backgroundColor: UIColor.clear
        ]
        
        self.navigationItem.title = countryName
        
        let url = URL(string: "https://raw.githubusercontent.com/russ666/all-countries-and-cities-json/master/countries.json")
        URLSession.shared.dataTask(with: url!, completionHandler: { [self](data, response, error) in
            showActivityIndicator()
            guard let data = data, error == nil else { return }
            do {
                self.cityData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                guard let cityArray = self.cityData?[self.countryName!] as? [String] else {
                    return
                }
                let keysArray = Array(self.cityData!.keys)
                print(keysArray)
                self.cityArray = cityArray
                for element in self.cityArray {
                    var isDuplicate = false
                    for uniqueElement in self.countryNameArrayWithoutDuplicates {
                        if element == uniqueElement {
                            isDuplicate = true
                            break
                        }
                    }
                    if !isDuplicate {
                        self.countryNameArrayWithoutDuplicates.append(element)
                    }
                }
                self.filteredArr = self.countryNameArrayWithoutDuplicates
                
                DispatchQueue.main.async {
                    // Your data loading code goes here
                    
                    // Hide activity indicator when data loading is complete
                    self.hideActivityIndicator()
                    self.cityTableView.reloadData()
                }
                
                //                DispatchQueue.main.async {
                //
                //                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mWAHomeScreenVC = MWAHomeScreenVC(nibName: "MWAHomeScreenVC", bundle: nil)
        mWAHomeScreenVC.cityName = self.filteredArr[indexPath.row]
        self.navigationController?.pushViewController(mWAHomeScreenVC, animated: true)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filteredArr = self.countryNameArrayWithoutDuplicates.filter({$0.contains(textField.text ?? "")})
        cityTableView.reloadData()
    }
    func showActivityIndicator() {
        isLoadingData = true
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.cityTableView.isUserInteractionEnabled = false
        }
    }
    
    func hideActivityIndicator() {
        isLoadingData = false
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.cityTableView.isUserInteractionEnabled = true
        }
    }
}
