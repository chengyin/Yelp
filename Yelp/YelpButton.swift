//
//  YelpButton.swift
//  Yelp
//
//  Created by chengyin_liu on 5/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

let BUTTON_EDGES_INSET = UIEdgeInsets(top: 8, left: 11, bottom: 8, right: 11)

class YelpButton: UIButton {
  let gradientLayer = CAGradientLayer()

  override var frame: CGRect {
    didSet {
      gradientLayer.frame = layer.bounds
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  init() {
    super.init(frame: CGRectZero)

    gradientLayer.colors = [
      UIColor(red:0.91, green:0.19, blue:0.13, alpha:1.00).CGColor,
      UIColor.yelpRedColor().CGColor
    ]

    gradientLayer.locations = [0, 1]

    gradientLayer.cornerRadius = 3.0
    gradientLayer.borderWidth = 1.0
    gradientLayer.borderColor = UIColor(red:0.40, green:0.03, blue:0.03, alpha:0.8).CGColor

    layer.addSublayer(gradientLayer)
    contentEdgeInsets = BUTTON_EDGES_INSET
    titleLabel?.textColor = UIColor.whiteColor()
    titleLabel?.font = UIFont.boldSystemFontOfSize(11)
  }

  override func sizeToFit() {
    super.sizeToFit()
  }
  

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
