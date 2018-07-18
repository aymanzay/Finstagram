//
//  SignInVC.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/1/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {

    private let HOME_SEGUE = "MainVC"
    
    @IBOutlet weak var emailTxtField: UITextField! //username or email
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.backgroundColor = UIColor.clear
        emailTxtField.tintColor = UIColor.white
        emailTxtField.textColor = UIColor.white
        emailTxtField.attributedPlaceholder = NSAttributedString(string: emailTxtField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 343, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        emailTxtField.layer.addSublayer(bottomLayer)
        
        passwordTxtField.backgroundColor = UIColor.clear
        passwordTxtField.tintColor = UIColor.white
        passwordTxtField.textColor = UIColor.white
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: passwordTxtField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 343, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        passwordTxtField.layer.addSublayer(bottomLayerPassword)
        
        signInButton.isEnabled = false
        
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Auto Sign in users already logged in previously
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer) in
                self.performSegue(withIdentifier: FinstaHandler.Instance.SIGNIN_SEGUE, sender: nil)
            })
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if emailTxtField.text != "" && passwordTxtField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTxtField.text!, password: passwordTxtField.text!, loginHandler: {(message) in
                
                if message != nil {
                    ProgressHUD.showError("Could not sign in")
                    //self.alertTheUser(title: "Problem with authentification", message: message!)
                } else {
                    ProgressHUD.showSuccess("Success")
                    //refreshing text fields at login
                    //FinstaHandler.Instance.username = self.emailTxtField.text!
                    self.emailTxtField.text = ""
                    self.passwordTxtField.text = ""
                    
                    self.performSegue(withIdentifier: FinstaHandler.Instance.SIGNIN_SEGUE, sender: nil)
                }
            })
            
        } else {
            //alertTheUser(title: "Email and password are required.", message: "Please enter email and password.")
            ProgressHUD.showError("Could not sign in")
        }
    }
    
    func handleTextField(){
        emailTxtField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTxtField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTxtField.text, !email.isEmpty, let password = passwordTxtField.text, !password.isEmpty else {
            signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signInButton.isEnabled = false
            return
        }
        
        signInButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
