//
//  CryptoRateData.swift
//  ByteCoin
//
//  Created by JorgeB on 10/02/22.
//

import Foundation

// MARK: - CryptoRateData
struct CryptoRateData: Codable {
    let rates: [Rate]
}

// MARK: - Rate
struct Rate: Codable {
    let assetIDQuote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case assetIDQuote = "asset_id_quote"
        case rate
    }
}
