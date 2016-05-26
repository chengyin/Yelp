//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum BusinessesResultViewType {
  case List, Map
}

class BusinessesViewController:
  UIViewController,
  UISearchBarDelegate,
  FiltersViewControllerDelegate,
  BussinessesDisplayViewControllerDelegate {

  @IBOutlet weak var subAreaView: UIView!

  var mapListSwitchButton: UIBarButtonItem!
  let searchBar = UISearchBar()
  var filters = Filters()
  var businesses: [Business] = []

  var displayType = BusinessesResultViewType.List
  var currentResultViewController: BusinessesDisplayViewControllerProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    configNavigationBar()
    loadSearchResultAppended(false)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    displayChildViewController(getChildViewControllerWithType(displayType))
  }

  func configNavigationBar() {
    mapListSwitchButton = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: #selector(BusinessesViewController.didTapMapListSwitchButton(_:)))

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filters", style: .Plain, target: self, action: #selector(BusinessesViewController.didTapFilters(_:)))
    navigationItem.titleView = searchBar
    navigationItem.rightBarButtonItem = mapListSwitchButton

    searchBar.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Child View Controller Management

  func getChildViewControllerWithType(type: BusinessesResultViewType) -> UIViewController {
    var vc: BusinessesDisplayViewControllerProtocol

    if (type == .List) {
      vc = BusinessesListViewController()
    } else {
      vc = BusinessesMapViewController()
    }

    vc.delegate = self

    return vc as! UIViewController
  }

  func displayChildViewController(viewController: UIViewController) {
    addChildViewController(viewController)
    addSubview(viewController.view, toView: subAreaView)
    viewController.didMoveToParentViewController(self)
    currentResultViewController = viewController as? BusinessesDisplayViewControllerProtocol
    self.reloadData()
  }

  func addSubview(subView: UIView, toView parentView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(subView)
    constrainSubView(subView, toView: parentView)
  }

  func constrainSubView(subView: UIView, toView parentView: UIView) {
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["subView"] = subView
    parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
      options: [], metrics: nil, views: viewBindingsDict))
    parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
      options: [], metrics: nil, views: viewBindingsDict))
  }

  func switchBetweenListAndMapViewController() {
    let vc = currentResultViewController as! UIViewController
    var nextType: BusinessesResultViewType
    var animationOption: UIViewAnimationOptions
    var nextLabel: String?

    if (displayType == .List) {
      nextType = .Map
      animationOption = .TransitionFlipFromRight
      nextLabel = "List"
    } else {
      nextType = .List
      animationOption = .TransitionFlipFromLeft
      nextLabel = "Map"
    }

    let nextVC = getChildViewControllerWithType(nextType)
    vc.willMoveToParentViewController(nil)

    addSubview(nextVC.view, toView: subAreaView)
    self.mapListSwitchButton.title = nextLabel

    UIView.transitionFromView(
      vc.view,
      toView: nextVC.view,
      duration: 0.6,
      options: animationOption,
      completion: { (finished) in
        if (finished) {
          vc.removeFromParentViewController()
          self.displayType = nextType
          self.currentResultViewController = nextVC as? BusinessesDisplayViewControllerProtocol
          self.reloadData()
        }
      }
    )
  }

  // MARK: - Navigation Bar Functions

  func didTapMapListSwitchButton(sender: AnyObject) {
    switchBetweenListAndMapViewController()
  }

  func didTapFilters(sender: AnyObject) {
    let vc = FiltersViewController.init(withFilters: filters)
    vc.delegate = self

    self.presentViewController(vc, animated: true, completion: nil)
  }

  // MARK: - Data Management

  func loadSearchResultAppended(appended: Bool, offset: Int? = nil, limit: Int? = nil, completion: (() -> ())? = nil ) {
    Business.searchWithFilters(filters, offset: offset, limit: limit) { (businesses: [Business]!, error: NSError!) in
      if (error != nil) {
        return;
      }

      if (appended) {
        self.businesses.appendContentsOf(businesses)
      } else {
        self.businesses = businesses ?? []
      }

      self.reloadData()
      completion?()
    }
  }

  func reloadData() {
    currentResultViewController?.setBusiness(businesses)
  }

  func loadNextPage(completion: (() -> ())? = nil) {
    loadSearchResultAppended(true, offset: self.businesses.count, completion: completion)
  }

  // MARK: - SearchBar

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    filters.term = searchBar.text ?? ""
    searchBar.resignFirstResponder()
    loadSearchResultAppended(false)
  }

  // MARK: - Filter

  func filtersViewControllerDidCancel(filtersViewController: FiltersViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  func filtersViewController(filtersViewController: FiltersViewController, didSubmitWithFilters filters: Filters) {
    self.filters = filters
    loadSearchResultAppended(false)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
