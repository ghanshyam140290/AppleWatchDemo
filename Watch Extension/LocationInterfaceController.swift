//
//  LocationInterfaceController.swift
//  Watch Extension
//
//  Created by Santosh Maurya on 26/06/18.
//  Copyright © 2018 Santosh Maurya. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class LocationInterfaceController: WKInterfaceController,CLLocationManagerDelegate {

    @IBOutlet var locationSlider: WKInterfaceSlider!
    
    @IBOutlet weak var mapObject: WKInterfaceMap!
    var mapLocation: CLLocationCoordinate2D?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.startGettingLocation()
       // updateLocation()
    }
    
    func startGettingLocation()  {
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegionMake(self.mapLocation!, span)
        self.mapObject.setRegion(region)
        
        self.mapObject.addAnnotation(self.mapLocation!,
                                     with: .red)
        locationManager.stopUpdatingLocation()
    }
 
   /*
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let currentLocation = locations[locations.count - 1]
            as? CLLocation
        
        var replyValues = Dictionary<String, AnyObject>()
        
        replyValues["latitude"] = currentLocation?.coordinate.latitude as AnyObject
        replyValues["longitude"] = currentLocation?.coordinate.longitude as AnyObject
        
        let lat = replyValues["latitude"] as! Double
        let long = replyValues["longitude"] as! Double
        
       // let lat = 28.6960
       // let long = 77.1526
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(self.mapLocation!,
                                            span)
        self.mapObject.setRegion(region)
        self.mapObject.addAnnotation(self.mapLocation!,
                                     with: .red)
        
        locationManager.stopUpdatingLocation()
        
    }*/
    
    func updateLocation() {
        
        let lat = 28.6960
        let long = 77.1526
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(self.mapLocation!,
                                            span)
        self.mapObject.setRegion(region)
        self.mapObject.addAnnotation(self.mapLocation!,
                                     with: .red)
    }
    
    @IBAction func changeMapRegion(_ value: Float) {
      
        let degrees:CLLocationDegrees = CLLocationDegrees(value) / 10

        let span = MKCoordinateSpanMake(degrees, degrees)
        let region = MKCoordinateRegionMake(self.mapLocation!, span)

        mapObject.setRegion(region)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        //self.startGettingLocation()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

  
}
