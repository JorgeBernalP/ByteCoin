//
//  SelectCryptoViewController.swift
//  ByteCoin
//
//  Created by JorgeB on 30/01/22.
//

import UIKit

protocol SelectCryptoDelegate {
    func didSelectCryptoOption(option: String)
}

class SelectCryptoViewController: UITableViewController {
    
    var delegate: SelectCryptoDelegate?
    
    let cryptoManager = CryptoManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Title Style
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Select a Crypto"
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoManager.cryptoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cryptoOption = cryptoManager.cryptoArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoOptionCell", for: indexPath)
        
        cell.textLabel?.text = cryptoOption
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedOption = cryptoManager.cryptoArray[indexPath.row]
        
        delegate?.didSelectCryptoOption(option: selectedOption)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
