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
  let code: String
  let getValue: () -> Bool
  let setValue: (Bool) -> ()
}

protocol FitlerSectionProtocol {
  var name: String? { get }
  var rowCount: Int { get }
}

struct FilterSwitchSection: FitlerSectionProtocol {
  let name: String?
  let switches: [FilterSwitch]

  var rowCount: Int {
    return switches.count
  }
}

struct FilterMultipleChoiceOption {
  let name: String
  let value: Any
}

struct FilterMultipleChoice: FitlerSectionProtocol {
  let name: String?
  let options: [FilterMultipleChoiceOption]
  let getSelectedIndex: () -> Int
  let setSelectedIndex: (Int) -> ()

  var rowCount: Int {
    return options.count
  }
}

let FILTER_OPTION_TOGGLE_CELL_ID = "filterOptionToggleCell"
let FILTER_CHOICE_FOLDED_CELL_ID = "filterChoiceFoldedCell"
let FILTER_CHOICE_OPTION_CELL_ID = "filterChoiceOptionCell"
let SEE_ALL_CELL_ID = "seeAllCell"

let filterDistanceOptions = [
  FilterMultipleChoiceOption(name: "0.25 miles", value: 402),
  FilterMultipleChoiceOption(name: "0.5 miles", value: 804),
  FilterMultipleChoiceOption(name: "2 miles", value: 3216),
  FilterMultipleChoiceOption(name: "5 miles", value: 8040),
  FilterMultipleChoiceOption(name: "10 miles", value: 16080),
]

let filterSortByOptions = [
  FilterMultipleChoiceOption(name: "Best Matched", value: YelpSortMode.BestMatched),
  FilterMultipleChoiceOption(name: "Distance", value: YelpSortMode.Distance),
  FilterMultipleChoiceOption(name: "Highest Rated", value: YelpSortMode.HighestRated)
]

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterOptionToggleCellDelegate {
  @IBOutlet weak var filtersTableView: UITableView!
  
  weak var delegate: FiltersViewControllerDelegate?
  var filters = Filters()
  var maxSwitchesInFoldedSection = 3

  var filterTable: [FitlerSectionProtocol] { return [
    FilterSwitchSection(
      name: nil,
      switches: [
        FilterSwitch(
          name: "Offers Deal",
          code: "deals",
          getValue: { () -> Bool in return self.filters.deals ?? false },
          setValue: { (value: Bool) in self.filters.deals = value }
        )
      ]
    ),

    FilterMultipleChoice(
      name: "Distance",
      options: filterDistanceOptions,
      getSelectedIndex: { () -> Int in
        return filterDistanceOptions.indexOf({ (option) -> Bool in
          return option.value as? Int == self.filters.radius
        }) ?? filterDistanceOptions.count - 1
      },
      setSelectedIndex: { (index) in
        self.filters.radius = filterDistanceOptions[index].value as? Int
      }
    ),

    FilterMultipleChoice(
      name: "Sort By",
      options: filterSortByOptions,
      getSelectedIndex: { () -> Int in
        return filterSortByOptions.indexOf({ (option) -> Bool in
          return option.value as? YelpSortMode == self.filters.sort
        }) ?? 0
      },
      setSelectedIndex: { (index) in
        self.filters.sort = filterSortByOptions[index].value as? YelpSortMode
      }
    ),

    FilterSwitchSection(
      name: "Category",
      switches: Category.all.map { category in
        return FilterSwitch(
          name: category.name!,
          code: category.code,
          getValue: { () -> Bool in return self.filters.categories.contains(category) },
          setValue: { (value) in
            if (value) {
              self.filters.categories.insert(category)
            } else {
              self.filters.categories.remove(category)
            }
          }
        )
      }
    )
  ] }

  var isExpandedAtSection: [Int: Bool] = [:]

  convenience init(withFilters filters: Filters) {
    self.init()
    self.filters = filters
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.filtersTableView.registerNib(
      UINib(nibName: "FilterOptionToggleCell", bundle: nil),
      forCellReuseIdentifier: FILTER_OPTION_TOGGLE_CELL_ID
    )

    self.filtersTableView.registerNib(
      UINib(nibName: "FilterChoiceFoldedCell", bundle: nil),
      forCellReuseIdentifier: FILTER_CHOICE_FOLDED_CELL_ID
    )

    self.filtersTableView.registerNib(
      UINib(nibName: "FilterChoiceOptionCell", bundle: nil),
      forCellReuseIdentifier: FILTER_CHOICE_OPTION_CELL_ID
    )

    self.filtersTableView.registerNib(
      UINib(nibName: "SeeAllTableViewCell", bundle: nil),
      forCellReuseIdentifier: SEE_ALL_CELL_ID
    )
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
    let fullCount = filterSection.rowCount

    if (filterSection is FilterSwitchSection) {
      if (fullCount <= maxSwitchesInFoldedSection) {
        return fullCount
      } else if (isExpandedAtSection[section] == true) {
        return fullCount
      } else {
        // 1 line more for see more
        return maxSwitchesInFoldedSection + 1
      }
    } else if (filterSection is FilterMultipleChoice) {
      if (isExpandedAtSection[section] == true) {
        return fullCount
      } else {
        return 1
      }
    }

    return fullCount
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    let filterSection = filterTable[section]

    if (filterSection is FilterSwitchSection) {
      if (row == maxSwitchesInFoldedSection && isExpandedAtSection[section] != true) {
        let cell = tableView.dequeueReusableCellWithIdentifier(SEE_ALL_CELL_ID, forIndexPath: indexPath)
        return cell
      } else if (row == filterSection.rowCount && isExpandedAtSection[section] == true) {
        let cell = tableView.dequeueReusableCellWithIdentifier(SEE_ALL_CELL_ID, forIndexPath: indexPath)
        return cell
      } else {
        let casted = filterSection as! FilterSwitchSection
        let filterRow = casted.switches[row]

        guard let cell = tableView.dequeueReusableCellWithIdentifier(
          FILTER_OPTION_TOGGLE_CELL_ID,
          forIndexPath: indexPath
          ) as? FilterOptionToggleCell else { return UITableViewCell() }

        cell.delegate = self
        cell.showOption(filterRow.name, value: filterRow.getValue())

        return cell
      }
    } else if (filterSection is FilterMultipleChoice) {
      let casted = filterSection as! FilterMultipleChoice
      let filterRow = casted.options[row]

      if (isExpandedAtSection[section] != true) {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(
          FILTER_CHOICE_FOLDED_CELL_ID,
          forIndexPath: indexPath
          ) as? FilterChoiceFoldedCell else { return UITableViewCell() }

        cell.showChoice(casted.options[casted.getSelectedIndex()].name)

        return cell
      } else {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(
          FILTER_CHOICE_OPTION_CELL_ID,
          forIndexPath: indexPath
          ) as? FilterChoiceOptionCell else { return UITableViewCell() }

        cell.showOption(filterRow.name, selected: casted.getSelectedIndex() == row)

        return cell
      }
    }

    return UITableViewCell()
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let section = indexPath.section

    if (cell is SeeAllTableViewCell) {
      isExpandedAtSection[section] = true

      var indexPaths: [NSIndexPath] = []

      for row in maxSwitchesInFoldedSection + 1 ..< filterTable[section].rowCount {
        indexPaths.append(NSIndexPath(forRow: row, inSection: section))
      }

      filtersTableView.beginUpdates()
      filtersTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: maxSwitchesInFoldedSection, inSection: section)], withRowAnimation: .Fade)
      filtersTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
      filtersTableView.endUpdates()
    } else if (cell is FilterChoiceFoldedCell) {
      isExpandedAtSection[section] = true

      filtersTableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    } else if (cell is FilterChoiceOptionCell) {
      isExpandedAtSection[section] = false

      let filterSection = filterTable[section] as! FilterMultipleChoice
      filterSection.setSelectedIndex(indexPath.row)

      filtersTableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }
  }

  func filterOptionToggleCell(filterOptionToggleCell: FilterOptionToggleCell, didChangeValue value: Bool) {
    let indexPath = filtersTableView.indexPathForCell(filterOptionToggleCell)!
    let filterSection = filterTable[indexPath.section]

    if (filterSection is FilterSwitchSection) {
      let casted = filterSection as! FilterSwitchSection
      let filterRow = casted.switches[indexPath.row]

      filterRow.setValue(value)
    }
  }
}
