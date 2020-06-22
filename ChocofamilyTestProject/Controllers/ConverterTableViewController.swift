//
//  ConverterTableViewController.swift
//  ChocofamilyTestProject
//
//  Created by Khaled on 21.06.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//


import UIKit

class ConverterTableViewController: UITableViewController{
    
    
    var price: Double = 100
    var currencyRate = CurrencyRate()
    var encodedCountries = [
        "AUD": "Australian dollar",
        "BRL": "Brazilian real",
        "BGN": "Bulgarian lev",
        "CAD": "Canadian dollar",
        "CNY": "Renminbi",
        "HRK": "Croatian kuna",
        "CZK": "Czech koruna",
        "DKK": "Danish krone",
        "GBP": "Pound sterling",
        "HKD": "Hong Kong dollar",
        "HUF": "Hungarian forint",
        "ILS": "Israeli new shekel",
        "INR": "Indian rupee",
        "IDR": "Indonesian rupiah",
        "ISK": "Icelandic króna",
        "JPY": "Japanese yen",
        "KRW": "South Korean won",
        "MXN": "Mexican peso",
        "MYR": "Malaysian ringgit",
        "EUR": "Euro",
        "NZD": "New Zealand dollar",
        "NOK": "Norwegian krone",
        "PHP": "Philippine peso",
        "PLN": "Polish złoty",
        "RON": "Romanian leu",
        "RUB": "Russian ruble",
        "SEK": "Swedish krona",
        "SGD": "Singapore dollar",
        "CHF": "Swiss franc",
        "THB": "Thai baht",
        "USD": "US dollar",
        "ZAR": "South African rand"
    ]
    
    var paths: [IndexPath] = []
    
    var currentCountry = "AUD"
    
    var counter = 0
    
    var timer = Timer()
    
    var currencyRates: Dictionary<String, Double> = [:]
    var arrayOfCountries: Array<(key: String, value: Double)> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.separatorStyle = .none
        //paths for all cells, exept first
        for i in 1...31{
            paths.append(IndexPath(row: i, section: 0))
        }
        
        fetchCurrencyRate(country: "AUD")
        scheduledTimerWithTimeInterval()
        
        
    }
    
    
   //change in the amount of money in the texfield
    @IBAction func textTapped(_ sender: UITextField) {
        if let number = Double(sender.text!){
            self.price = number
        } else {
            self.price = 0.0
        }
        
        self.tableView.reloadRows(at: self.paths, with: UITableView.RowAnimation.none)
    }
    
    //timer to update function every second
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    //fetching data from api every second
    @objc func updateCounting(){
        let topVisibleIndexPath:IndexPath = self.tableView.indexPathsForVisibleRows![0]

        print(currentCountry)
        fetchCurrencyRate(country: currentCountry)
    }
    
    
    //function for fetching data
    func fetchCurrencyRate(country: String){
        currencyRate.fetchRate(country: country) { (dict) in
            DispatchQueue.main.sync {
                self.currencyRates = dict!
                if self.counter == 0{
                    
                    self.arrayOfCountries = self.currencyRates.sorted(by: { $0.0 < $1.0 })
                    self.arrayOfCountries.insert((key: country, value: 1), at: 0)
                    self.currencyRates[country] = 1
                    
                } else {
                    self.currencyRates[country] = 1
                }
                
                //for the first time we update all tableview, and for the rest of the time update all cells exept first
                if self.counter == 0{
                    self.tableView.reloadData()
                } else {
                    self.tableView.reloadRows(at: self.paths, with: UITableView.RowAnimation.none)
                }

                
                
            }
        }
    }
    
    //choosing currency and placing it on the first place
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! RatesTableViewCell
        
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.endUpdates()
        
        currentCountry = arrayOfCountries[indexPath.row].key
        
        arrayOfCountries.insert(arrayOfCountries.remove(at: indexPath.row), at: 0)
        
        
        currentCell.moneyTextField.isEnabled = true
        
        self.price = Double(currentCell.moneyTextField.text!)!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencyRates.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rates", for: indexPath) as! RatesTableViewCell
        
        let key = arrayOfCountries[indexPath.row].key
        
        //updating values from the dictionary which loads every second
        for i in 0..<arrayOfCountries.count{
            if arrayOfCountries[i].key == key{
                arrayOfCountries[i].value = currencyRates[key]!
            }
        }
        
        let value = arrayOfCountries[indexPath.row].value
        //set up cell content
        if let image = UIImage(named: key){
                counter = counter + 1
                cell.update(image: image, code: key, currency: encodedCountries[key]!, money: "\(Double(round(100*value*price)/100))")
        } else{
            print(key, "oshibka")
        }
        
        cell.moneyTextField.isEnabled = false
        
        return cell
    }
    

}
