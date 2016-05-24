//
//  FiltersViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
  func filtersViewControllerDidCancel(filtersViewController: FiltersViewController);
  func filtersViewController(filtersViewController: FiltersViewController, didSubmitWithFilters filters: Filters);
}

struct FilterSwitch {
  let name: String
  let code: String?
  var on: Bool
}

protocol FitlerSectionProtocol {
  var name: String? { get }
}

struct FilterSwitchSection: FitlerSectionProtocol {
  let name: String?
  let switches: [FilterSwitch]
}

struct FilterMultipleChoiceOption {
  let name: String
  let value: Any
}

struct FilterMultipleChoice: FitlerSectionProtocol {
  let name: String?
  let options: [FilterMultipleChoiceOption]
  let value: Any
}

let FILTER_OPTION_TOGGLE_CELL_ID = "filterOptionToggleCell"

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterOptionToggleCellDelegate {

  @IBOutlet weak var filtersTableView: UITableView!
  
  weak var delegate: FiltersViewControllerDelegate?
  var filters = Filters()

  var filterTable: [FitlerSectionProtocol] {
    return [
      FilterSwitchSection(name: nil, switches: [
        FilterSwitch(name: "Offers Deal", code: nil, on: filters.deals ?? false)
      ]),

      FilterMultipleChoice(name: "Distance", options: [
        FilterMultipleChoiceOption(name: "0.25 miles", value: 0.25)
      ], value: 0.25),

      FilterMultipleChoice(name: "Sort By", options: [
        FilterMultipleChoiceOption(name: "Best Matched", value: YelpSortMode.BestMatched),
        FilterMultipleChoiceOption(name: "Distance", value: YelpSortMode.Distance),
        FilterMultipleChoiceOption(name: "Highest Rated", value: YelpSortMode.HighestRated)
      ], value: YelpSortMode.BestMatched),

      FilterSwitchSection(name: "Category", switches: Category.all.map { category in
        return FilterSwitch(name: category.name, code: category.code, on: false)
      }),
    ]
  }

  convenience init(withFilters filters: Filters) {
    self.init()
    self.filters = filters
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let nib = UINib(nibName: "FilterOptionToggleCell", bundle: nil)
    self.filtersTableView.registerNib(nib, forCellReuseIdentifier: FILTER_OPTION_TOGGLE_CELL_ID)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  // MARK: -

  @IBAction func didTapCancel(sender: AnyObject) {
    self.delegate?.filtersViewControllerDidCancel(self)
  }

  @IBAction func didTapDone(sender: AnyObject) {
    self.delegate?.filtersViewController(self, didSubmitWithFilters: filters)
  }

  // MARK: - Table

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return filterTable.count
  }

  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return filterTable[section].name
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let filterSection = filterTable[section]

    if (filterSection is FilterSwitchSection) {
      let casted = filterSection as! FilterSwitchSection
      return casted.switches.count
    } else if (filterSection is FilterMultipleChoice) {
      let casted = filterSection as! FilterMultipleChoice
      return casted.options.count
    }

    return 0;
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    let filterSection = filterTable[section]

    if (filterSection is FilterSwitchSection) {
      let casted = filterSection as! FilterSwitchSection
      let filterRow = casted.switches[row]

      guard let row = tableView.dequeueReusableCellWithIdentifier(FILTER_OPTION_TOGGLE_CELL_ID, forIndexPath: indexPath) as? FilterOptionToggleCell else { return UITableViewCell() }

      row.delegate = self
      row.showOption(filterRow.name, value: filterRow.on)

      return row
    }

    return UITableViewCell()
  }

  func filterOptionToggleCell(filterOptionToggleCell: FilterOptionToggleCell, didChangeValue value: Bool) {
    let indexPath = filtersTableView.indexPathForCell(filterOptionToggleCell)
    print(indexPath)
  }
}
