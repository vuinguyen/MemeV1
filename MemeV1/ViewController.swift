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
                                                          NSAttributedString.Key.font:
                                                            UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ??
                                                              UIFont(name: "Impact", size: 40)!,
                                                          NSAttributedString.Key.strokeWidth: -2.0];
  let topFieldDefaultText = "TOP"
  let bottomFieldDefaultText = "BOTTOM"
  var memedImage: UIImage?

  // MARK: Properties
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  @IBOutlet weak var bottomToolbar: UIToolbar!
  @IBOutlet weak var navBar: UIToolbar!
  
  // MARK: Actions
  @IBAction func cancelMeme(_ sender: Any) {
    topTextField.text = topFieldDefaultText
    bottomTextField.text = bottomFieldDefaultText
    memeImageView.image = nil
    shareButton.isEnabled = false
  }

  @IBAction func shareMeme(_ sender: Any) {
    // generate the meme
    let generatedImage = generateMemedImage()

    // share it out
    // and then save it! (to Meme struct)
    let controller = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
    self.present(controller, animated: true, completion: save)
  }

  @IBAction func pickImageFromCamera(_ sender: Any) {
    pickImage(isSourceAlbum: false)
  }

  @IBAction func pickImageFromAlbum(_ sender: Any) {
    pickImage(isSourceAlbum: true)
  }

  private func pickImage(isSourceAlbum: Bool) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = isSourceAlbum ? .photoLibrary : .camera
    present(imagePickerController, animated: true, completion: nil)
  }

  // MARK: ViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    topTextField.text = topFieldDefaultText
    topTextField.backgroundColor = UIColor.clear
    topTextField.borderStyle = .none
    topTextField.defaultTextAttributes = memeTextAttributes
    topTextField.textAlignment = .center
    topTextField.delegate = self

    bottomTextField.text = bottomFieldDefaultText
    bottomTextField.backgroundColor = UIColor.clear
    bottomTextField.borderStyle = .none
    bottomTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.textAlignment = .center
    bottomTextField.delegate = self

    if memeImageView.image == nil {
      shareButton.isEnabled = false
    }
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
      shareButton.isEnabled = true
    } else {
      print("That was the wrong key")
    }
    picker.dismiss(animated: true, completion: nil)
  }

  // MARK: TextFieldDelegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == topTextField && textField.text == topFieldDefaultText {
        textField.text = ""
    } else if textField == bottomTextField && textField.text == bottomFieldDefaultText {
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

  // MARK: Meme Generating Helper Functions
  func generateMemedImage() -> UIImage {
    // hide toolbar and navbar
    self.bottomToolbar.isHidden = true
    self.navBar.isHidden = true

    // Render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    // show toolbar and navbar
    self.bottomToolbar.isHidden = false
    self.navBar.isHidden = false

    self.memedImage = memedImage
    return memedImage
  }

  func save() {
    let meme = Meme(topText: topTextField.text ?? topFieldDefaultText, bottomText: bottomTextField.text ?? bottomFieldDefaultText, originalImage: memeImageView.image, memedImage: memedImage)
  }
}

