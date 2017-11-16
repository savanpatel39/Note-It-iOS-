//
//  MapViewController.swift
//  Testing 1.1
//
//  Created by Savan Patel on 2016-02-28.
//  Copyright © 2016 Savan Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager();
    
    var location : CLLocationCoordinate2D!;
    var latitude : CLLocationDegrees!;
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       locationManager.delegate = self
        let location1 = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude);
        showAnnotationOnMap(location1);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAnnotationOnMap(locatoin : CLLocationCoordinate2D)
    {        
        let span = MKCoordinateSpanMake(0.006, 0.006);
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true);
        
        
        let annotation = MKPointAnnotation();
        
        annotation.coordinate = location;
        annotation.title = "You took this note here!!";
        
        mapView.addAnnotation(annotation);
    }
}
