//
//  CryptoImageData.swift
//  ByteCoin
//
//  Created by JorgeB on 2/02/22.
//

import Foundation

struct CryptoImageData: Codable {
    let assetID: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case url
    }
}
