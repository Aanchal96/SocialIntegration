//
//  MapsViewController.swift
//  SocialIntegration
//
//  Created by Appinventiv on 27/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
        self.mapShow()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapsViewController{
    func mapShow(){
        let camera = GMSCameraPosition.camera(withLatitude: 28.6059923, longitude: 77.3622606, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.6059923, longitude: 77.3622606)
        marker.title = "Appinventiv Technologies"
        marker.snippet = "Noida"
        marker.map = mapView
    }
}
