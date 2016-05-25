//
//  FilterChoiceFoldedCell.swift
//  Yelp
//
//  Created by chengyin_liu on 5/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterChoiceFoldedCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()

    accessoryView = UIImageView(image: UIImage(named: "chevron-down.png"))
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

//    if (selected) {
//      UIView.animateWithDuration(animated ? 0.25 : 0.0, animations: {
//        self.accessoryView!.transform = CGAffineTransformMakeRotation((180 * CGFloat(M_PI)) / 180.0)
//      })
//    } else {
//      UIView.animateWithDuration(animated ? 0.25 : 0.0, animations: {
//        self.accessoryView!.transform = CGAffineTransformMakeRotation((0 * CGFloat(M_PI)) / 180.0)
//      })
//    }
  }

  func showChoice(choice: String) {
    textLabel!.text = choice
  }

}
