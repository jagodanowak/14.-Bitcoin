//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1   // number of columns
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyName = coinManager.currencyArray[row]   //title for given row
        return currencyName
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]    //record the row number which was selected
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
    
    
    
    func didUpdateCurrency(_ coinManager: CoinManager, price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = price
        }
    }

    
    func didFailWithError(error: Error) {
        print(error)
    }
}

