//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

let BUSINESS_PLACEHOLD_IMAGE = UIImage(named: "yelp-placeholder.png")

class BusinessTableViewCell: UITableViewCell {

  @IBOutlet weak var businessImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!


  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func showBusiness(business: Business) {
    nameLabel.text = business.name
    addressLabel.text = business.address
    categoriesLabel.text = business.categories
    distanceLabel.text = business.distance

    if (business.imageURL != nil) {
      businessImageView.setImageWithURL(business.imageURL!)
    } else {
      businessImageView.image = BUSINESS_PLACEHOLD_IMAGE
    }

    if (business.ratingImageURL != nil) {
      ratingImageView.setImageWithURL(business.ratingImageURL!)
    } else {
      ratingImageView.image = UIImage()
    }

    if (business.reviewCount != nil) {
      reviewCountLabel.text = "\(business.reviewCount!) Reviews"
    } else {
      reviewCountLabel.text = ""
    }
  }

}
