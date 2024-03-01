//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Eshan Verma on 25/08/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var searchBarTextField: UITextField!
    var filteredArr : [String] = []
    let countries = [
        "Nepal", "Bulgaria", "Iceland", "Swaziland", "Uruguay", "Namibia", "Tunisia", "Mongolia", "Barbados", "Papua New Guinea", "Tanzania", "Ecuador", "Czech Republic", "Saint Lucia", "United Arab Emirates", "Cyprus", "Estonia", "New Caledonia", "Egypt", "Trinidad and Tobago", "Greenland", "New Zealand", "Liechtenstein", "Haiti", "Turkey", "Guatemala", "Hashemite Kingdom of Jordan", "Bolivia", "Taiwan", "Libya", "French Polynesia", "Argentina", "Cameroon", "Philippines", "Guadeloupe", "Latvia", "Belgium", "Mayotte", "Singapore", "Madagascar", "Australia", "Panama", "Suriname", "Greece", "Luxembourg", "Kosovo", "Cambodia", "Venezuela", "Botswana", "Myanmar [Burma]", "Cayman Islands", "India", "Aruba", "Afghanistan", "Antigua and Barbuda", "Gabon", "Kazakhstan", "Croatia", "Saudi Arabia", "China", "Malaysia", "Sudan", "Iraq", "Germany", "Morocco", "Zimbabwe", "Serbia", "Ireland", "Guinea", "Faroe Islands", "Israel", "Netherlands", "Paraguay", "Thailand", "Mauritius", "Isle of Man", "Algeria", "France", "Slovenia", "Belarus", "Zambia", "Andorra", "San Marino", "Austria", "Norway", "Congo", "Oman", "Costa Rica", "Slovakia", "Sweden", "Palestine", "Bosnia and Herzegovina", "Republic of Moldova", "Russia", "Senegal", "Denmark", "Malta", "Armenia", "Finland", "Iran", "Republic of Lithuania", "Poland", "Italy", "Nigeria", "Nicaragua", "United States", "Hungary", "Pakistan", "Japan", "Indonesia", "Bahrain", "Republic of Korea", "Angola", "Spain", "Bangladesh", "Macedonia", "Romania", "South Africa", "Dominican Republic", "Azerbaijan", "Colombia", "Vietnam", "Georgia", "Brazil", "Brunei", "Kenya", "Sri Lanka", "Albania", "U.S. Virgin Islands", "Hong Kong", "Canada", "Belize", "Ukraine", "Honduras", "Bahamas", "Mozambique", "Mexico", "Chile", "Kuwait", "Jamaica", "El Salvador", "Cuba", "Lebanon", "United Kingdom", "Montenegro", "Switzerland", "Martinique", "Portugal", "Ghana", "Peru", "Puerto Rico", "Guam"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableView.delegate = self
        countryTableView.dataSource = self
        searchBarTextField.delegate = self
        countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        filteredArr = countries
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArr.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredArr[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 18.0)
        return cell
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        searchBarTextField.resignFirstResponder()
        if(filteredArr.count == 0){
            filteredArr = countries;
            countryTableView.reloadData()
            searchBarTextField.layer.borderWidth = 2
            searchBarTextField.layer.borderColor = UIColor.red.cgColor
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mWAHomeScreenVC = MWAHomeScreenVC(nibName: "MWAHomeScreenVC", bundle: nil)
//        mWAHomeScreenVC.countryName = filteredArr[indexPath.row]
//
//        self.navigationController?.pushViewController(mWAHomeScreenVC, animated: true)
        
//        CityViewController
        
        let cityViewController = CityViewController(nibName: "CityViewController", bundle: nil)
        cityViewController.countryName = filteredArr[indexPath.row]

        self.navigationController?.pushViewController(cityViewController, animated: true)
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filteredArr = countries.filter({$0.contains(textField.text ?? "")})
        countryTableView.reloadData()
    }
    
}

