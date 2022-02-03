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
    
    var cryptoName : String = ""
    var cryptoPrice : String = ""
    var currency : String = ""
    var cryptoId : String = ""
    
    var currencyPickerSelected = ""
    
    var cryptos = ["Bitcoin"]
    
    var currencyPicker = UIPickerView()
    let currencyPickerToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        cryptoManager.delegate = self
        currencyPicker.dataSource = self
        
        cryptoManager.getCryptoPrice(for: "USD", in: "BTC")
        
        //Default value
        
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        tableView.showsVerticalScrollIndicator = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        cryptoManager.getCryptoPrice(for: currencyPickerSelected, in: cryptoId)
    }

    @IBAction func addCryptoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSelectCrypto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? SelectCryptoViewController
        destinationVC?.delegate = self
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
            self.descriptionLabel.text = "Check the current prices of cryptocurrency arround the world in \(self.currencyPickerSelected)."
            cell.currencyValue.text = self.cryptoPrice
            cell.currencyName.text = self.currency
            cell.cryptoName.text = self.cryptoName
            cell.cryptoShortName.text = self.cryptoId
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
        return cryptoManager.currencyDict.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoManager.orderedCurrencyDict[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPickerSelected = cryptoManager.orderedCurrencyDict[row].value
    }
    
}

//MARK: - CryptoManagerDelegate

extension CryptoViewController: CryptoManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String, crypto: String) {
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

//MARK: - SelectCryptoDelegate

extension CryptoViewController: SelectCryptoDelegate {
    
    func didSelectCryptoOption(name: String, crypto: String) {
        
        DispatchQueue.main.async {
            self.cryptos.append(crypto)
            self.cryptoId = crypto
            self.cryptoName = name
            self.tableView.reloadData()
        }
        
    }
    
}


