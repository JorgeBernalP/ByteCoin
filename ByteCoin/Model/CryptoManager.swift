//
//  CryptoData.swift
//  ByteCoin
//
//  Created by JorgeB on 29/01/22.
//

import Foundation
import CoreLocation

protocol CryptoManagerDelegate {
    func didUpdatePrice(price: String, currency: String, crypto: String)
    func didFailWithError(error: Error)
}

struct CryptoManager {
    
    var delegate : CryptoManagerDelegate?
    
    let rateURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "244BBAF1-FC77-4E6D-8113-C4247FFC041F"
    
//    let currencyArray = ["AUD", "BRL","CAD", "COP", "CNY","EUR","GBP","HKD", "INR","JPY","MXN","RUB","USD"]
    
    let currencyDict = ["Australian Dollar" : "AUD", "Brazilian Real" : "BRL", "Canadian Dollar" : "CAD", "Colombian Peso" : "COP", "Chinese Yuan" : "CNY", "Euro" : "EUR", "Pound sterling" : "GBP", "Hong Kong Dollar" : "HKD", "Indian Rupee" : "INR", "Japanese Yen" : "JPY", "MXN" : "Mexican Peso", "Russian Rubble" : "RUB", "United States Dollar" : "USD"]
    
    lazy var orderedCurrencyDict = currencyDict.sorted(by: <)
    
//    let cryptoArray = ["BTC", "ETH", "BNB", "ADA", "SOL", "XRP", "LUNA", "DOGE", "DOT", "AVAX"]
    
    let cryptoDict = ["Bitcoin" : "BTC", "Ethereum": "ETH", "BNB" : "BNB", "Cardano": "ADA", "Solano" : "SOL", "XRP" : "XRP", "TERRA" : "LUNA" , "Dogecoin" : "DOGE", "Polkadot" : "DOT", "Avalanche" : "AVAX" ]
    
    lazy var orderedCryptoDict = cryptoDict.sorted(by: <)
    
    
    
    func getCryptoPrice(for currency: String, in crypto: String) {
        
        let urlString = "\(rateURL)/\(crypto)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let cryptoPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "$%.02f", cryptoPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency, crypto: crypto)
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
