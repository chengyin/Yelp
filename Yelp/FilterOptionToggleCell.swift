//
//  FilterOptionToggleCell.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterOptionToggleCellDelegate: class {
  func filterOptionToggleCell(filterOptionToggleCell: FilterOptionToggleCell, didChangeValue value: Bool)
}

class FilterOptionToggleCell: UITableViewCell, YelpSwitchControlDelegate {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueSwitch: YelpSwitchControl!

  weak var delegate: FilterOptionToggleCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    valueSwitch.delegate = self
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func showOption(name: String, value: Bool) {
    nameLabel.text = name
    valueSwitch.on = value
  }

  func yelpSwitchControl(yelpSwitchControl: YelpSwitchControl, didChangeValue on: Bool) {
    self.delegate?.filterOptionToggleCell(self, didChangeValue: on)
  }
}
