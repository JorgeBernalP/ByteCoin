//
//  ViewController.swift
//  ByteCoin
//
//  Created by JorgeB on 28/01/22.
//

import UIKit
import NeumorphismKit

class CryptoViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cryptoButton: NeumorphismButton!
    @IBOutlet weak var currencyButton: NeumorphismButton!
    
    let cryptos = ["Bitcoin", "Ethereum", "Dogecoin", "Avalanche", "NEAR Protocol", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        tableView.showsVerticalScrollIndicator = false

        //Description Text
        descriptionLabel.text = "Check the current prices of cryptocurrency arround the world in Colombian Peso."
    
    }

}

//MARK: - TableView Data Source

extension CryptoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let crypto = cryptos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoCell
        
        cell.cryptoName.text = crypto
        
        cell.backgroundColor = UIColor(ciColor: .clear)
        
        //Remove cell bg
        
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate

extension CryptoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

