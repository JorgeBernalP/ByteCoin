//
//  CryptoData.swift
//  ByteCoin
//
//  Created by JorgeB on 29/01/22.
//

import Foundation
import CoreLocation

protocol CryptoManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CryptoManager {
    
    var delegate : CryptoManagerDelegate?
    
    let rateURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "244BBAF1-FC77-4E6D-8113-C4247FFC041F"
    
    let currencyArray = ["AUD", "BRL","CAD", "COP", "CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let cryptoArray = ["BTC", "ETH", "BNB", "ADA", "SOL", "XRP", "LUNA", "DOGE", "DOT", "AVAX"]
    
    func getCryptoPrice(for currency: String) {
        
        let urlString = "\(rateURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let cryptoPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "$%.02f", cryptoPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CryptoData.self, from: data)
            
            let price = decodedData.rate
            
            return price
            
        } catch {
            return nil
        }
    }
    
}
