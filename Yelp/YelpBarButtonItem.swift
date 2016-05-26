//
//  YelpBarButtonItem.swift
//  Yelp
//
//  Created by chengyin_liu on 5/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  class func initYelpButtonWithTitle(title: String) -> UIBarButtonItem {
    let button = UIButton()

    button.backgroundColor = UIColor.yelpRedColor()
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.setTitle(title, forState: .Normal)

    return UIBarButtonItem.init(customView: button)
  }
}