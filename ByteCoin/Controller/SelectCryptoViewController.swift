//
//  SelectCryptoViewController.swift
//  ByteCoin
//
//  Created by JorgeB on 30/01/22.
//

import UIKit

protocol SelectCryptoDelegate {
    func didSelectCryptoOption(name: String, crypto: String)
}

class SelectCryptoViewController: UITableViewController {
    
    var delegate: SelectCryptoDelegate?
    
    var cryptoManager = CryptoManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 56

        //Title Style
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Select a Crypto"
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoManager.cryptoDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let namesArray = cryptoManager.orderedCryptoDict[indexPath.row].key
        let abbrArray = cryptoManager.orderedCryptoDict[indexPath.row].value
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoOptionCell", for: indexPath)
        
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
        
        delegate?.didSelectCryptoOption(name: selectedName, crypto: selectedCrypto)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
