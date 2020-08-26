//
//  Box.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation

final class Box<T> {
  //  1 : notifies when the value changes.
  typealias Listener = (T) -> Void
  var listener: Listener?
  // 2 : The didSet property observer detects any changes and notifies Listener of any value update.
  var value: T {
    didSet {
      listener?(value)
    }
  }
  // 3
  init(_ value: T) {
    self.value = value
  }
  // 4
  func bind(listener: Listener?){
    self.listener = listener
    listener?(value)
  }
}
