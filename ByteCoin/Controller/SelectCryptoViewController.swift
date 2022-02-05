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
    
    var cryptoManager = CryptoManager()
    
    var cryptoImageManager = CryptoImageManager()
    
    var cryptoImageArray: [CryptoImageData] = []
    
    var namesArray = ""
    var abbrArray = ""
    var imagesArray : [URL?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cryptoImageManager.delegate = self
        
        tableView.rowHeight = 56

        //Title Style
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Select a Crypto"
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cryptoImageManager.getCryptoImage()
        
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
            cell.imageView?.kf.setImage(with: imagesArray[indexPath.row])
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
        
        let cryptoSelected = Crypto(cryptoImage: imagesArray[indexPath.row], cryptoName: selectedName, cryptoAbbr: selectedCrypto, currencyValue: "0", currencyName: "USD")
        
        delegate?.didSelectCryptoOption(crypto: cryptoSelected)
        
        navigationController?.popViewController(animated: true)
        
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
