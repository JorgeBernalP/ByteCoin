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
    
    var cryptoManager = CryptoManager()
    
    var cryptoPrice : String = ""
    var currency : String = ""
    
    let cryptos = ["Bitcoin", "Ethereum", "Dogecoin", "Avalanche", "NEAR Protocol", "3", "4", "5"]
    
    var currencyPicker = UIPickerView()
    var currencyPickerSelcted = ""
    let currencyPickerToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        cryptoManager.delegate = self
        currencyPicker.dataSource = self
        
        //Default value
        cryptoManager.getCryptoPrice(for: "USD")
        
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        tableView.showsVerticalScrollIndicator = false
    
    }
    
    @IBAction func currencyPressed(_ sender: UIButton) {
        
        //Create the UIPicker
        currencyPicker.delegate = self
        currencyPicker.backgroundColor = UIColor(named: "ByteCoin Blue")
        currencyPicker.setValue(UIColor.white, forKey: "textColor")
        currencyPicker.autoresizingMask = .flexibleWidth
        currencyPicker.contentMode = .bottom
        currencyPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(currencyPicker)
        
        currencyPickerToolBar.barTintColor = UIColor(named: "ByteCoin Blue")
        currencyPickerToolBar.tintColor = UIColor(named: "ByteCoin Green")
        currencyPickerToolBar.items = [UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(currencyPickerToolBar)
        
    }

    @objc func onDoneButtonTapped() {
        currencyPickerToolBar.removeFromSuperview()
        currencyPicker.removeFromSuperview()
        cryptoManager.getCryptoPrice(for: currencyPickerSelcted)
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
        
        DispatchQueue.main.async {
            self.descriptionLabel.text = "Check the current prices of cryptocurrency arround the world in \(self.currency)."
            cell.currencyValue.text = self.cryptoPrice
            cell.currencyName.text = self.currency
        }
        
        cell.backgroundColor = UIColor(ciColor: .clear)
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate

extension CryptoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

//MARK: - UIPicker DataSource & Delegate

extension CryptoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPickerSelcted = cryptoManager.currencyArray[row]
    }
    
}

//MARK: - CryptoManagerDelegate

extension CryptoViewController: CryptoManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.cryptoPrice = price
            self.currency = currency
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

