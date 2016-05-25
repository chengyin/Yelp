//
//  Filters.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

struct Filters {
  var term: String = ""
  var sort: YelpSortMode?
  var radius: Int?
  var categories = Set<Category>()
  var deals: Bool?

  var categoryCodes: [String]? {
    return categories.map { (category) -> String in
      return category.code
    }
  }
}