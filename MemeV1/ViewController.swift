//
//  ViewController.swift
//  MemeV1
//
//  Created by Vui Nguyen on 10/2/18.
//  Copyright © 2018 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate,
                      UINavigationControllerDelegate {

  let memeTextAttributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key.strokeColor: UIColor.black,
                                          NSAttributedString.Key.foregroundColor: UIColor.white,
                                          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? UIFont(name: "Impact", size: 40)!,
                                          NSAttributedString.Key.strokeWidth: 5];

  // MARK: Properties
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  
  // MARK: Actions
  @IBAction func pickImageFromCamera(_ sender: Any) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .camera
    present(imagePickerController, animated: true, completion: nil)
  }

  @IBAction func pickImageFromAlbum(_ sender: Any) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @IBAction func shareMeme(_ sender: Any) {
  }

  // MARK: ViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    topTextField.text = "TOP"
    topTextField.defaultTextAttributes = memeTextAttributes
    topTextField.textAlignment = .center
    topTextField.delegate = self

    bottomTextField.text = "BOTTOM"
    bottomTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.textAlignment = .center
    bottomTextField.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    subscribeToKeyboardNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }

  // MARK: ImagePickerControllerDelegate
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      memeImageView.image = image
    } else {
      print("That was the wrong key")
    }
    picker.dismiss(animated: true, completion: nil)
  }

  //https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/ManageTextFieldTextViews/ManageTextFieldTextViews.html
  //https://stackoverflow.com/questions/30630582/ios-swift-delegate-with-more-than-1-uitextfield-in-a-uiview

  // use tags to identify which textfield you're talking about
  // MARK: TextFieldDelegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == topTextField && textField.text == "TOP" {
        textField.text = ""
    } else if textField == bottomTextField && textField.text == "BOTTOM" {
        textField.text = ""
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == topTextField || textField == bottomTextField {
      textField.resignFirstResponder()
    }
    return true
  }

  // MARK: Keyboard Helper Functions
  @objc func keyboardWillShow(_ notification: Notification) {
    // ensure that the keyboard moves up ONLY when the bottom text field is being edited
    if bottomTextField.isEditing {
      view.frame.origin.y = -getKeyboardHeight(notification)
    }
  }

  @objc func keyboardWillHide(_ notification: Notification) {
    view.frame.origin.y = 0
  }

  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
  }

  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}

