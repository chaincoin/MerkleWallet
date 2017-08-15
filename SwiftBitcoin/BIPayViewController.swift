//
//  BIPayViewController.swift
//  SwiftBitcoin
//
//  Created by Yusuke Asai on 2017/07/01.
//  Copyright © 2017年 Yusuke Asai. All rights reserved.
//

import UIKit

public protocol BIPayViewControllerDelegate {
    func paymentCanceled()
}

class BIPayViewController: UIViewController {
    
    public var addressStr: String? = nil
    public var amountStr: String? = nil
    
    //public var doubleDismiss = false
    
    public var qrCodeReadViewController: BIQRCodeReadViewController? = nil
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    public var delegate: BIPayViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.adjustsFontSizeToFitWidth = true
        
        addressTextField.text = addressStr
        amountTextField.text = amountStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.paymentCanceled()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        
        let privatePrefix = BitcoinPrefixes.privatePrefix
        let pubkeyPrefix = BitcoinPrefixes.pubKeyPrefix
        let minimumAmount: Int64 = 547
        
        guard let addressStr = addressTextField.text else {
            print("Address is nil")
            return
        }
        
        guard let amountStr = amountTextField.text else {
            print("Amount is nil")
            return
        }
        
        guard let type = addressStr.determinOutputScriptTypeWithAddress() else {
            print("Could not determin address type")
            return
        }
        
        var prefix = pubkeyPrefix
        
        if type == .P2SH {
            prefix = BitcoinPrefixes.scriptHashPrefix
        }
        
        if let pubkeyHash = addressStr.publicAddressToPubKeyHash(prefix) {
            
            if let amount = Double(amountStr) {
                let convertedInBtc = Int64(amount * 100000000)
                if convertedInBtc > minimumAmount {
                    let txConstructor = TransactionDBConstructor(privateKeyPrefix: privatePrefix, publicKeyPrefix: pubkeyPrefix, sendAmount: convertedInBtc, to: RIPEMD160HASH(pubkeyHash.hexStringToNSData().reversedData), type: type, fee: 90000)
                    
                    print("Amount : \(convertedInBtc)")
                    //print(txConstructor.transaction ?? "no tx")
                    print(txConstructor.transaction?.bitcoinData.toHexString() ?? "no val")

                } else {
                    print("Entered amount is nil. Miminum amount is \(minimumAmount) satoshi.")
                }
                
            } else {
                print("Failed to converted amount properly")
                return
            }
            
        } else {
            print("Invalid address")
            return
        }
        
        if qrCodeReadViewController != nil {
            let presentingViewController: UIViewController! = self.presentingViewController
            
            qrCodeReadViewController!.dismiss(animated: false, completion: {
                presentingViewController.dismiss(animated: true, completion: nil)
            })
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

