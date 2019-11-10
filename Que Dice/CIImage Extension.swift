//
//  CIImage Extension.swift
//  Que Dice
//
//  Created by Michelle Cueva on 11/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

extension CIImage {
  func toUIImage() -> UIImage? {
    let context: CIContext = CIContext.init(options: nil)

    if let cgImage: CGImage = context.createCGImage(self, from: self.extent) {
      return UIImage(cgImage: cgImage)
    } else {
      return nil
    }
  }
}
