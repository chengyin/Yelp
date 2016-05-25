//
//  SearchResultsViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

let BUSINESS_CELL_ID = "businessCell"
let SEARCH_RESULT_CELL_ESTIMATED_HEIGHT: CGFloat = 80.0

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var navigationBarTitleItem: UINavigationItem!

  let searchBar = UISearchBar()

  var filters = Filters()
  var businesses: [Business] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    configTableView()
    configNavigationBar()

    loadSearchResultAppended(false)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  func configTableView() {
    let businessCellNib = UINib.init(nibName: "BusinessTableViewCell", bundle: nil)
    tableView.registerNib(businessCellNib, forCellReuseIdentifier: BUSINESS_CELL_ID)
    tableView.estimatedRowHeight = SEARCH_RESULT_CELL_ESTIMATED_HEIGHT
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  func configNavigationBar() {
    navigationBarTitleItem.titleView = searchBar
    searchBar.delegate = self
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

  // MARK: - Data

  func loadSearchResultAppended(appended: Bool, offset: Int? = nil, limit: Int? = nil) {
    Business.searchWithFilters(filters, offset: offset, limit: limit) { (businesses: [Business]!, error: NSError!) in
      if (error != nil) {
        return;
      }

      if (appended) {
        self.businesses.appendContentsOf(businesses)
      } else {
        self.businesses = businesses ?? []
      }

      self.tableView.reloadData()
    }
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
      loadSearchResultAppended(true, offset: self.businesses.count)
      startInfiniteScrollLoading()
    }

    return cell
  }

  // MARK: - SearchBar

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    filters.term = searchBar.text ?? ""
    searchBar.resignFirstResponder()
    loadSearchResultAppended(false)
  }

  // MARK: - Filter

  @IBAction func didTapFilters(sender: AnyObject) {
    let vc = FiltersViewController.init(withFilters: filters)
    vc.delegate = self

    self.presentViewController(vc, animated: true, completion: nil)
  }

  func filtersViewControllerDidCancel(filtersViewController: FiltersViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  func filtersViewController(filtersViewController: FiltersViewController, didSubmitWithFilters filters: Filters) {
    self.filters = filters
    loadSearchResultAppended(false)
    self.dismissViewControllerAnimated(true, completion: nil)
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
