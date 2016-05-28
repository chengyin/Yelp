//
//  BusinessesNavigationViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesNavigationViewController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let vc = BusinessesViewController()
    pushViewController(vc, animated: true)
    navigationBar.translucent = false
    navigationBar.barTintColor = UIColor(red:0.79, green:0.09, blue:0.09, alpha:1.00)
    navigationBar.tintColor = UIColor.whiteColor()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
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
