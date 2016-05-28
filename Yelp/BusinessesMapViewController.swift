//
//  BusinessesMapViewController.swift
//  Yelp
//
//  Created by chengyin_liu on 5/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class YelpMapAnnotation: MKPointAnnotation {
  var business: Business!

  override var coordinate: CLLocationCoordinate2D {
    get {
      return CLLocationCoordinate2D(latitude: business.lat!, longitude: business.lon!)
    }

    set {}
  }

  override var title: String? {
    get {
      return business?.name
    }

    set {}
  }
}

class BusinessesMapViewController:
  UIViewController,
  MKMapViewDelegate,
  BusinessesDisplayViewControllerProtocol {

  @IBOutlet weak var mapView: MKMapView!

  var firstLoad = true
  var businesses: [Business] = []
  weak var delegate: BussinessesDisplayViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self
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

      let annotation = YelpMapAnnotation()
      annotation.business = business

      annotations.append(annotation)
    }

    mapView.showAnnotations(annotations, animated: !firstLoad)
    firstLoad = false
  }

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation is YelpMapAnnotation) {
      let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "yelpPin")

      if #available(iOS 9.0, *) {
        pinAnnotationView.pinTintColor = UIColor.yelpRedColor()
      }

      pinAnnotationView.draggable = false
      pinAnnotationView.canShowCallout = true
      pinAnnotationView.animatesDrop = !firstLoad

      let button = UIButton(type: .DetailDisclosure)
      pinAnnotationView.rightCalloutAccessoryView = button

      return pinAnnotationView
    }

    return nil
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let annotation = view.annotation as? YelpMapAnnotation

    if (annotation != nil) {
      delegate?.didSelectedBusiness(annotation!.business)
    }
  }
}
