//
//  CryptoImageManager.swift
//  ByteCoin
//
//  Created by JorgeB on 2/02/22.
//

import Foundation

protocol CryptoImageDelegate {
    func didGetCryptoImage(cryptoImg: [CryptoImageData])
}

struct CryptoImageManager {
    
    var delegate: CryptoImageDelegate?
    
    let imageURL = "https://rest.coinapi.io/v1/assets/icons/24"
    let apiKey = "244BBAF1-FC77-4E6D-8113-C4247FFC041F"
    
    func getCryptoImage() {
        
        let urlString = "\(imageURL)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    if let cryptoImages = self.parseJSON(safeData) {
                        delegate?.didGetCryptoImage(cryptoImg: cryptoImages)
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ data: Data) -> [CryptoImageData]? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode([CryptoImageData].self, from: data)
            
            return decodedData
            
        } catch {
            return nil
        }
    }
    
}
