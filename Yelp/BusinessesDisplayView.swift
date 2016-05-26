//
//  BusinessesDisplayViewProtocol.swift
//  Yelp
//
//  Created by chengyin_liu on 5/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol BussinessesDisplayViewControllerDelegate: class {
  func loadNextPage(completion: (() -> ())?)
}

protocol BusinessesDisplayViewControllerProtocol {
  weak var delegate: BussinessesDisplayViewControllerDelegate? { get set }
  func setBusiness(businesses: [Business])
}