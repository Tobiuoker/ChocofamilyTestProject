//
//  CurrencyRate.swift
//  ChocofamilyTestProject
//
//  Created by Khaled on 21.06.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import Foundation

class CurrencyRate{
    
    //function for fetching data from api
    func fetchRate(country: String, completion: @escaping (Dictionary<String, Double>?) -> Void) {
        let query = [
            "base": "\(country)"
        ]
        let url = URL(string: "https://hiring.revolut.codes/api/android/latest")!
        
        guard let newUrl = url.withQueries(query) else {return}
        
        URLSession.shared.dataTask(with:newUrl) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {

                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String : Any]

                    let dict = parsedData["rates"] as! Dictionary<String, Double>
                    
                    completion(dict)

                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }

            }.resume()
        
    }
}
