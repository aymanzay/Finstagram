//
//  SignUpVC.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/2/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var selectedImage: UIImage?

class SignUpVC: UIViewController {
    
    private let HOME_SEGUE = "HomeVC"
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    //dismiss sign up screen
    @IBAction func dismissOnClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
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
        
        usernameTxtField.backgroundColor = UIColor.clear
        usernameTxtField.tintColor = UIColor.white
        usernameTxtField.textColor = UIColor.white
        usernameTxtField.attributedPlaceholder = NSAttributedString(string: usernameTxtField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let bottomLayerUsername = CALayer()
        
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 343, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        usernameTxtField.layer.addSublayer(bottomLayerUsername)
        
        profileImage.layer.cornerRadius = 64
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField(){
        usernameTxtField.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTxtField.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTxtField.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTxtField.text, !username.isEmpty, let email = emailTxtField.text, !email.isEmpty, let password = passwordTxtField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        
        signUpButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        
        //getting image data to save in database + storage
        let imageData = UIImageJPEGRepresentation(selectedImage!, 0.1)
        
        AuthProvider.Instance.signup(withEmail: emailTxtField.text!, withUsername: usernameTxtField.text!, password: passwordTxtField.text!, profileImg: imageData, loginHandler: {(message) in
            
            if message != nil {
                ProgressHUD.showError("Could not authenticate.")
                //self.alertTheUser(title: "Problem authenticating. Try again.", message: message!)
            } else {
                //refresh on success
                ProgressHUD.showSuccess("Success")
                FinstaHandler.Instance.username = self.usernameTxtField.text!
                
                self.usernameTxtField.text = ""
                self.emailTxtField.text = ""
                self.passwordTxtField.text = ""
                
                self.performSegue(withIdentifier: FinstaHandler.Instance.SIGNUP_SEGUE, sender: nil)
            }
        })
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
