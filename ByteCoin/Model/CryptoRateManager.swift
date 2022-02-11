//
//  CryptoRateManager.swift
//  ByteCoin
//
//  Created by JorgeB on 10/02/22.
//

import Foundation

protocol CryptoRateDelegate {
    func didGetCryptoRates(crypto: String, rates: [Rate])
}

struct CryptoRateManager {
    
    var delegate: CryptoRateDelegate?
    
    let rateURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "244BBAF1-FC77-4E6D-8113-C4247FFC041F"
    
    func getCryptoRates(for crypto: String) {
        
        let urlString = "\(rateURL)\(crypto)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    if let safeRates = self.parseJSON(safeData) {
                        self.delegate?.didGetCryptoRates(crypto: crypto, rates: safeRates)
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ data: Data) -> [Rate]? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CryptoRateData.self, from: data)
            
            let prices = decodedData.rates
            
            return prices
            
        } catch {
            return []
        }
    }
    
}
