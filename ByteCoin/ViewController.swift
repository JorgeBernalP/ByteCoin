//
//  ViewController.swift
//  ByteCoin
//
//  Created by JorgeB on 28/01/22.
//

import UIKit
import NeumorphismKit

class ViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cryptoButton: NeumorphismButton!
    @IBOutlet weak var currencyButton: NeumorphismButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Description Text
        descriptionLabel.text = "Check the current prices of cryptocurrency arround the world in Colombian Peso."
    
    }

}

