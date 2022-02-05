//
//  CryptoCell.swift
//  ByteCoin
//
//  Created by JorgeB on 29/01/22.
//

import UIKit

class CryptoCell: UITableViewCell {
    
    @IBOutlet weak var imageCointainer: UIView!
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var cryptoShortName: UILabel!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageCointainer.layer.cornerRadius = 24
        imageCointainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with crypto: Crypto) {
        
        cryptoImage.kf.setImage(with: crypto.cryptoImage)
        cryptoName.text = crypto.cryptoName
        cryptoShortName.text = crypto.cryptoAbbr
        currencyValue.text = crypto.currencyValue
        currencyName.text = crypto.currencyName
        
    }
    
}

