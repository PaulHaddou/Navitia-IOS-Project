//
//  ViewController.swift
//  DooWap
//
//  Created by Paul Haddou on 13/01/2020.
//  Copyright © 2020 Paul Haddou. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapScreen: UIViewController {
    
    ///
    /// Add Bars
    
    
    //Coordinates of the bars
    let bar1Latitude = 48.845969
    let bar1Longitude = 2.343564
    let bar2Latitude = 48.8498571
    let bar2Longitude = 2.3549651
    let bar3Latitude = 48.8332913
    let bar3Longitude = 2.3338394

    
    //Buttons to add bars
    
    
    func addAnnotations() {
        let theoBarAnnotation = MKPointAnnotation()
        theoBarAnnotation.title = "Théo Bar"
        theoBarAnnotation.coordinate = CLLocationCoordinate2D(latitude: bar1Latitude , longitude: bar1Longitude)
            

        mapView.addAnnotation(theoBarAnnotation)
        
        let emmaBarAnnotation = MKPointAnnotation()
        emmaBarAnnotation.title = "Emma Bar"
        emmaBarAnnotation.coordinate = CLLocationCoordinate2D(latitude: bar2Latitude , longitude: bar2Longitude)
            

        mapView.addAnnotation(emmaBarAnnotation)
        
        let paulBarAnnotation = MKPointAnnotation()
        paulBarAnnotation.title = "Paul's Bar"
        paulBarAnnotation.coordinate = CLLocationCoordinate2D(latitude: bar3Latitude , longitude: bar3Longitude)
            

        mapView.addAnnotation(paulBarAnnotation)
    }
    
    

    
    
    ///
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1500

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        addAnnotations()
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
            
        }
    }
      
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
        
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
            let latitude = mapView.centerCoordinate.latitude
            let longitude = mapView.centerCoordinate.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
    }
}


//Follow the user when he moves

extension MapScreen: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }
         let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
         let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
         mapView.setRegion(region, animated: true)
     }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func mapView (_ apView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        
        return renderer
    }
}



