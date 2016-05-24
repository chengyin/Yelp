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

class FilterOptionToggleCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueSwitch: UISwitch!

  weak var delegate: FilterOptionToggleCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func showOption(name: String, value: Bool) {
    nameLabel.text = name
    valueSwitch.on = value
  }

  @IBAction func switchDidChangeValue(sender: UISwitch) {
    self.delegate?.filterOptionToggleCell(self, didChangeValue: sender.on)
  }
}
