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
    
    var selectedImage : URL?
    var selectedFullName : String?
    
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
        
        selectedFullName = cryptoManager.orderedCryptoDict[indexPath.row].key
        
        if imagesArray.count > 0 {
            selectedImage = imagesArray[indexPath.row]
        }
        
        let selectedCrypto = cryptoManager.orderedCryptoDict[indexPath.row].value
        
        cryptoManager.getCryptoPrice(for: selectedCurrency!, in: selectedCrypto)
        
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
    
    func didUpdatePrice(price: String, currency: String, crypto: String) {
//        self.cryptoValue = price
        
        if imagesArray.count > 0 {
                
                let cryptoSelected = Crypto(cryptoImage: selectedImage, cryptoName: selectedFullName!, cryptoAbbr: crypto, currencyValue: price, currencyName: currency)
                
                delegate?.didSelectCryptoOption(crypto: cryptoSelected)
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
