//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!

  var business: Business!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    showBusiness(business)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func showBusiness(business: Business) {
    nameLabel.text = business.name
    addressLabel.text = business.address
    categoriesLabel.text = business.categories
    distanceLabel.text = business.distance

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

    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2D(latitude: business.lat!, longitude: business.lon!)
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)

    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
    mapView.setRegion(
      region,
      animated: false
    )
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
