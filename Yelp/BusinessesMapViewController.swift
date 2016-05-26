//
//  BusinessesMapViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesMapViewController: UIViewController, BusinessesDisplayViewControllerProtocol {

  @IBOutlet weak var mapView: MKMapView!

  var businesses: [Business] = []
  weak var delegate: BussinessesDisplayViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func setBusiness(businesses: [Business]) {
    mapView.removeAnnotations(mapView.annotations)
    self.businesses = businesses
    addBusinessesOntoMap()
  }

  func addBusinessesOntoMap() {
    var annotations: [MKPointAnnotation] = []

    for business in self.businesses {
      let lat = business.lat
      let lon = business.lon

      if (lat == nil || lon == nil) {
        continue;
      }

      let annotation = MKPointAnnotation()

      annotation.coordinate = CLLocationCoordinate2D(latitude: business.lat!, longitude: business.lon!)
      annotation.title = business.name
      annotations.append(annotation)
    }

    mapView.showAnnotations(annotations, animated: true)  }
}
