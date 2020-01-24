//
//  SearchFooter.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class SearchFooter: UIView {
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configureView()
  }
  
  override func draw(_ rect: CGRect) {
    label.frame = bounds
  }
  
  func setNotFiltering() {
    label.text = ""
    hideFooter()
  }
  
  func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
    if (filteredItemCount == totalItemCount) {
      setNotFiltering()
    } else if (filteredItemCount == 0) {
      label.text = "No items match your query"
      showFooter()
    } else {
      label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
      showFooter()
    }
  }
  
  func hideFooter() {
    UIView.animate(withDuration: 0.7) {
      self.alpha = 0.0
    }
  }
  
  func showFooter() {
    UIView.animate(withDuration: 0.7) {
      self.alpha = 1.0
    }
  }
  
  func configureView() {
    backgroundColor = UIColor.fakeWhite
    alpha = 0.0
    
    label.textAlignment = .center
    label.textColor = UIColor.white
    addSubview(label)
  }
}
