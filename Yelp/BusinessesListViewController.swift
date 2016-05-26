//
//  BusinessesListViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

let BUSINESS_CELL_ID = "businessCell"
let SEARCH_RESULT_CELL_ESTIMATED_HEIGHT: CGFloat = 80.0

class BusinessesListViewController: UIViewController, BusinessesDisplayViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  var businesses: [Business] = []
  weak var delegate: BussinessesDisplayViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    configTableView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setBusiness(businesses: [Business]) {
    self.businesses = businesses
    self.tableView.reloadData()
  }

  func configTableView() {
    let businessCellNib = UINib.init(nibName: "BusinessTableViewCell", bundle: nil)
    tableView.registerNib(businessCellNib, forCellReuseIdentifier: BUSINESS_CELL_ID)
    tableView.estimatedRowHeight = SEARCH_RESULT_CELL_ESTIMATED_HEIGHT
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  func startInfiniteScrollLoading() {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    spinner.startAnimating()
    spinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: SEARCH_RESULT_CELL_ESTIMATED_HEIGHT)
    spinner.color = UIColor.yelpLightGray()

    tableView.tableFooterView = spinner
  }

  func endLoading() {
    tableView.tableFooterView = nil
  }

  // MARK: - TableView

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return businesses.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(BUSINESS_CELL_ID, forIndexPath: indexPath) as? BusinessTableViewCell
      else { return UITableViewCell() }

    cell.showBusiness(self.businesses[indexPath.row])

    // infinite scrolling
    if (indexPath.row == self.businesses.count - 2) {
      delegate?.loadNextPage({ 
        self.endLoading()
      })

      startInfiniteScrollLoading()
    }

    return cell
  }
}
