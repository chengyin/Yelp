//
//  FilterChoiceOptionCell.swift
//  Yelp
//
//  Created by chengyin_liu on 5/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterChoiceOptionCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    if (selected) {
      accessoryType = .Checkmark
    }

    // Configure the view for the selected state
  }

  func showOption(option: String, selected: Bool) {
    textLabel!.text = option

    if (selected) {
      accessoryType = .Checkmark
    } else {
      accessoryType = .None
    }
  }
}
