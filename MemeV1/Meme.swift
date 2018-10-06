//
//  Meme.swift
//  MemeV1
//
//  Created by Vui Nguyen on 10/6/18.
//  Copyright © 2018 Sunfish Empire. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
  var topText: String?
  var bottomText: String?
  var originalImage: UIImage?
  var memedImage: UIImage?

  init(topText: String, bottomText: String, originalImage: UIImage?, memedImage: UIImage?) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
}
