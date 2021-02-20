//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(error: Error)
}



struct CoinManager {
    
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=A2851456-CE2B-431F-A25B-289AA270EA6B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        
        let urlString = baseURL + "/\(currency)" + apiKey
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let lastPrice = parseJSON(bitcoinData: safeData) {
                        let lastPriceString = String(format: "%.2f", lastPrice)
                        self.delegate?.didUpdateCurrency(self, price: lastPriceString, currency: currency)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSON(bitcoinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BitcoinData.self, from: bitcoinData)
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

