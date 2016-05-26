//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
  let name: String?
  let address: String?
  let imageURL: NSURL?
  let categories: String?
  let distance: String?
  let ratingImageURL: NSURL?
  let reviewCount: NSNumber?
  let lat: Double?
  let lon: Double?

  init(dictionary: NSDictionary) {
    name = dictionary["name"] as? String

    let imageURLString = dictionary["image_url"] as? String
    if imageURLString != nil {
      imageURL = NSURL(string: imageURLString!)!
    } else {
      imageURL = nil
    }

    let location = dictionary["location"] as? NSDictionary
    var address = ""
    var lat: Double? = nil
    var lon: Double? = nil
    if location != nil {
      let addressArray = location!["address"] as? NSArray
      if addressArray != nil && addressArray!.count > 0 {
        address = addressArray![0] as! String
      }

      let neighborhoods = location!["neighborhoods"] as? NSArray
      if neighborhoods != nil && neighborhoods!.count > 0 {
        if !address.isEmpty {
          address += ", "
        }
        address += neighborhoods![0] as! String
      }

      let coordinate = location!["coordinate"] as? NSDictionary
      if coordinate != nil {
        lat = coordinate!["latitude"] as? Double ?? nil
        lon = coordinate!["longitude"] as? Double ?? nil
      }
    }

    self.address = address
    self.lat = lat
    self.lon = lon

    let categoriesArray = dictionary["categories"] as? [[String]]
    if categoriesArray != nil {
      var categoryNames = [String]()
      for category in categoriesArray! {
        let categoryName = category[0]
        categoryNames.append(categoryName)
      }
      categories = categoryNames.joinWithSeparator(", ")
    } else {
      categories = nil
    }

    let distanceMeters = dictionary["distance"] as? NSNumber
    if distanceMeters != nil {
      let milesPerMeter = 0.000621371
      distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
    } else {
      distance = nil
    }

    let ratingImageURLString = dictionary["rating_img_url_large"] as? String
    if ratingImageURLString != nil {
      ratingImageURL = NSURL(string: ratingImageURLString!)
    } else {
      ratingImageURL = nil
    }

    reviewCount = dictionary["review_count"] as? NSNumber
  }

  class func businesses(array array: [NSDictionary]) -> [Business] {
    var businesses = [Business]()
    for dictionary in array {
      let business = Business(dictionary: dictionary)
      businesses.append(business)
    }
    return businesses
  }

  class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
    YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
  }

  class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Int?, completion: ([Business]!, NSError!) -> Void) -> Void {
    YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, radius: radius, completion: completion)
  }
  
  class func searchWithFilters(filters: Filters, offset: Int? = nil, limit: Int? = nil, completion:  ([Business]!, NSError!) -> Void) {
    YelpClient.sharedInstance.searchWithTerm(
      filters.term,
      sort: filters.sort,
      categories: filters.categoryCodes,
      deals: filters.deals,
      radius: filters.radius,
      offset: offset,
      limit: limit,
      completion: completion
    )
  }
}
