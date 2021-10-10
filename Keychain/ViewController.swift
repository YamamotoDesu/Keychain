//
//  ViewController.swift
//  Keychain
//
//  Created by 山本響 on 2021/10/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func savePassword(_ sender: UIButton) {
        guard let password = passwordText.text else {
            let alert = UIAlertController(title: "Error", message: "Empty Password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let data = Data(password.utf8)
        KeychainHelper.standard.save(data, service: "password", account: "yamamoto")
        setPasswordLabel()
        
        
    }
    
    @IBAction func deletePassword(_ sender: UIButton) {
        KeychainHelper.standard.delete(service: "password", account: "yamamoto")
        setPasswordLabel()
    }
    
    func setPasswordLabel() {
        guard let data = KeychainHelper.standard.read(service: "password", account: "yamamoto") else {
            passwordLabel.text = "Keychain"
            return
        }
        let accessPassword = String(data: data, encoding: .utf8)!
        passwordLabel.text = accessPassword
    }
}

