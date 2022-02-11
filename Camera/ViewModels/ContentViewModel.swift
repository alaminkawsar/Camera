//
//  ContentViewModel.swift
//  Camera
//
//  Created by Khayrul on 2/11/22.
//

import Foundation

import CoreImage
import VideoToolbox

class ContentViewModel: ObservableObject {
  
  @Published var frame: CGImage?
        
  
  private let frameManager = FrameManager.shared

  init() {
    setupSubscriptions()
  }
  
  func setupSubscriptions() {
    // 1
    frameManager.$current
      // 2
      .receive(on: RunLoop.main)
      // 3
      .compactMap { buffer in
        return CGImage.create(from: buffer)

      }
      // 4
      .assign(to: &$frame)

  }
}
