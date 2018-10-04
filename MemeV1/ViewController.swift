//
//  ViewController.swift
//  MemeV1
//
//  Created by Vui Nguyen on 10/2/18.
//  Copyright © 2018 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
}

