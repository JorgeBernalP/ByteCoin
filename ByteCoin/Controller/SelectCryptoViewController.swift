//
//  SelectCryptoViewController.swift
//  ByteCoin
//
//  Created by JorgeB on 30/01/22.
//

import UIKit
import Kingfisher

protocol SelectCryptoDelegate {
    func didSelectCryptoOption(crypto: Crypto)
}

class SelectCryptoViewController: UITableViewController {
    
    var delegate: SelectCryptoDelegate?
    
    var cryptoView = CryptoViewController()
    
    var cryptoManager = CryptoManager()
    
    var cryptoImageManager = CryptoImageManager()
    
    var cryptoImageArray: [CryptoImageData] = []
    
    var namesArray = ""
    var abbrArray = ""
    var selectedCurrency : String? {
        return cryptoView.currencyPickerSelected
    }
    var cryptoValue: String?
    var imagesArray : [URL?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cryptoValue ?? "No price")

        cryptoManager.delegate = self
        cryptoImageManager.delegate = self
        
        tableView.rowHeight = 56
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        DispatchQueue.main.async {
            self.cryptoImageManager.getCryptoImage()
        }

        //Title Style
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Select a Crypto"
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    func getImage() {
        if let safeImage = cryptoImageArray.first(where: { image in
            image.assetID == self.abbrArray
        }) {
            imagesArray.append(URL(string: safeImage.url))
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoManager.cryptoDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        namesArray = cryptoManager.orderedCryptoDict[indexPath.row].key
        abbrArray = cryptoManager.orderedCryptoDict[indexPath.row].value
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoOptionCell", for: indexPath)
        
        getImage()
        
        if imagesArray.count > 0 {
            
            let processor = DownsamplingImageProcessor(size: CGSize(width: 16, height: 16))
            cell.imageView?.kf.setImage(with: imagesArray[indexPath.row], options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        }
        
        cell.textLabel?.text = namesArray
        cell.detailTextLabel?.text = abbrArray
        
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        cell.detailTextLabel?.textColor = UIColor(named: "ByteCoin Green")
        
        cell.backgroundColor = UIColor(ciColor: .clear)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedName = cryptoManager.orderedCryptoDict[indexPath.row].key
        
        let selectedCrypto = cryptoManager.orderedCryptoDict[indexPath.row].value
        
        cryptoManager.getCryptoPrice(for: selectedCurrency!, in: selectedCrypto)
        
        if imagesArray.count > 0 {
            
            if let safeValue = cryptoValue {
                
                let cryptoSelected = Crypto(cryptoImage: imagesArray[indexPath.row], cryptoName: selectedName, cryptoAbbr: selectedCrypto, currencyValue: safeValue, currencyName: selectedCurrency!)
                
                delegate?.didSelectCryptoOption(crypto: cryptoSelected)
                
            }
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
}

extension SelectCryptoViewController: CryptoImageDelegate {
    
    func didGetCryptoImage(cryptoImg: [CryptoImageData]) {
        DispatchQueue.main.async {
            self.cryptoImageArray = cryptoImg
            self.tableView.reloadData()
        }
    }
    
}

extension SelectCryptoViewController: CryptoManagerDelegate {
    
    func didUpdatePrice(price: String) {
        self.cryptoValue = price
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
