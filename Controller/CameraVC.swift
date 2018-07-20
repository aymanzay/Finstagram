//
//  CameraVC.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/2/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import FirebaseAuth

class CameraVC: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        
        clean()
        
        shareButton.isEnabled = false
        shareButton.backgroundColor = .lightGray
        
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        removeButton.isEnabled = false
        
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHost()
    }
    
    func handleHost() {
        if selectedImage != nil { //when a photo is selected
            shareButton.isEnabled = true
            removeButton.isEnabled = true
            shareButton.backgroundColor = .black
        }else{
            shareButton.isEnabled = false
            removeButton.isEnabled = false
            
            shareButton.backgroundColor = .lightGray
            shareButton.setTitleColor(.black, for: .disabled)
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        clean()
        handleHost()
    }
    
    func clean() {
        photo.image = #imageLiteral(resourceName: "placeholder-photo")
        captionTextView.text = ""
        selectedImage = nil
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        
        if let _ = self.selectedImage, let imageData = UIImageJPEGRepresentation(photo.image!, 0.1) {
            let photoIdString = NSUUID().uuidString
            
            StorageProvider.Instance.savePostPhoto(withID: photoIdString, img: imageData, caption: captionTextView.text!)
            
        } else {
            ProgressHUD.showError("Image not found.")
        }
        
        self.tabBarController?.selectedIndex = 0
        photo.image = #imageLiteral(resourceName: "placeholder-photo")
        captionTextView.text = ""
        selectedImage = nil
    }
    
} // end of class

extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

//EOF
