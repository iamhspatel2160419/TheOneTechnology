//
//  MapViewController.swift
//  iVergeByHp
//
//  Created by Apple on 22/12/20.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import GooglePlaces
import SDWebImage

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate  {
    
    let locationManager = CLLocationManager()
    var latValue = CLLocationDegrees()
    var longValue = CLLocationDegrees()
    var markerArray = Array<Any>()
    var i : Int = 0
    var origin = String()
    var destination = String()
    
    var previousLat = CLLocationDegrees()
    var previousLong = CLLocationDegrees()
    
    var customInfoWindow : CustomInfoWindow?
    var tappedMarker : GMSMarker?
    var listItem = [MapDetail]()
    
    
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        getCurrentLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: 13.096079826355, longitude: 80.2916030883789, zoom: 1.0) // point the initial location of map
        
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        initializeYourMap()
        
    }
    func getCurrentLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization() // Call the authorizationStatus() class
        if CLLocationManager.locationServicesEnabled() { // get my current locations lat, lng
            
            let lat = locationManager.location?.coordinate.latitude
            let long = locationManager.location?.coordinate.longitude
            if let lattitude = lat  {
                if let longitude = long {
                    latValue = lattitude
                    longValue = longitude
                } else {
                    
                }
            } else {
                
                print("problem to find lat and lng")
            }
            
        }
        else {
            print("Location Service not Enabled. Plz enable u'r location services")
        }
    }
    func initializeYourMap() {
        
        var latLongArray : NSArray?
        if let path = Bundle.main.path(forResource: "stations", ofType: "plist"){
            latLongArray = NSArray(contentsOfFile : path)
        }
        
        if let items = latLongArray {
            for item in items {
                let latitude    = (item as AnyObject).value(forKey: "lat")
                let longitude   = (item as AnyObject).value(forKey: "long")
                
                
                let title = ((item as AnyObject).value(forKey: "title")) as! String
                let logo = ((item as AnyObject).value(forKey: "logo") )as! String
                let business_name = ((item as AnyObject).value(forKey:"business_name")) as! String
                let business_address = ((item as AnyObject).value(forKey: "business_address")) as! String
                let website = ((item as AnyObject).value(forKey: "website")) as! String
                let mobile = ((item as AnyObject).value(forKey: "mobile")) as! String
               
                let obj  = MapDetail(title:title,
                                     logo:logo,
                                     business_name:business_name,
                                     business_address:business_address,
                                     website:website,
                                     mobile:mobile)
                listItem.append(obj)
                
                drawMarker(title: title,lat: latitude as! CLLocationDegrees ,long: longitude as! CLLocationDegrees, mapDetail: obj)
                drawPath(title: title, lat: latitude as! CLLocationDegrees , long: longitude as! CLLocationDegrees)
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let object = marker.userData as! MapDetail
        
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 100
        customInfoWindow?.url = object.website
        guard let url = URL(string: object.logo) else { return false }
        customInfoWindow?.logoImage.sd_setImage(with: url,placeholderImage:UIImage(contentsOfFile:""))

        customInfoWindow?.lblBusinessName.text = object.business_name
       
        customInfoWindow?.lblBusinessAddress.text = object.business_address
        self.mapView.addSubview(customInfoWindow!)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 100
    }
    
    
    
    func drawMarker(title: String, lat: CLLocationDegrees , long: CLLocationDegrees, mapDetail: MapDetail ) {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = title
        marker.snippet = "GoogleMap"
        marker.map = mapView
        marker.userData = mapDetail
        
    }
    
    func drawPath(title: String, lat: CLLocationDegrees , long: CLLocationDegrees) {
        
        if i == 0 {
            origin = "\(lat),\(long)"
            destination = "\(lat),\(long)"
            
        } else {
            destination = "\(lat),\(long)"
        }
        i=1
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        origin = "\(lat),\(long)"
        AF.request(url).responseJSON { response in
            
            let json = try!  JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
            
        }
    }
}
