//
//  ViewController.swift
//  SJSU Interactive Map
//
//  Created by Liping on 11/10/15.
//  Copyright © 2015 Liping. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    // Building data
    var buildingMarkers = [BuildingMarker]()
    let campusTopLeft = CLLocation(latitude: 37.337161, longitude: -121.887881)
    let campusTopRight = CLLocation(latitude: 37.340737, longitude: -121.880252)
    let campusBottomLeft = CLLocation(latitude: 37.330761, longitude: -121.883152)
    let campusBottomRight = CLLocation(latitude: 37.334337, longitude: -121.875502)
    
    // ScrollView
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // CLLocationManagerDelegate
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    @IBOutlet var locationMaker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Building data
        loadBuildings()
        for buildingMarker in buildingMarkers {
            let label = UILabel()
            label.text = buildingMarker.name
            label.font = UIFont.systemFontOfSize(10)
            label.numberOfLines = 0
            label.textColor = UIColor.blackColor()
            buildingMarker.label = label
            imageView.addSubview(label)
            
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "building-marker"), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("buttonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            buildingMarker.button = button
            imageView.addSubview(button)
        }
        
        // ScrollView
        imageView.image = UIImage(named: "campusmap")
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        
        // CLLocationManagerDelegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Search
        searchBar.delegate = self
    }
    
    
    /* -------------------------------- Building data -------------------------------- */
    func loadBuildings() {
        let photo1 = UIImage(named: "KingLibrary")!
        let building1 = BuildingMarker(name: "King Library", photo: photo1,
            address: "150 E San Fernando St, San Jose, CA 95112", lat: 37.335491, lng: -121.885141)!
        
        let photo2 = UIImage(named: "EngineeringBuilding")!
        let building2 = BuildingMarker(name: "Engineering Building", photo: photo2,
            address: "San José State University Charles W. Davidson College of Engineering, 1 Washington Square, San Jose, CA 95112", lat: 37.337098, lng: -121.881831)!
        
        let photo3 = UIImage(named: "YoshihiroUchidaHall")!
        let building3 = BuildingMarker(name: "Yoshihiro Uchida Hall", photo: photo3,
            address: "Yoshihiro Uchida Hall, San Jose, CA 95112",
            lat: 37.333658, lng: -121.883880)!
        
        let photo4 = UIImage(named: "StudentUnion")!
        let building4 = BuildingMarker(name: "Student Union", photo: photo4,
            address: "Student Union Building, San Jose, CA 95112",
            lat: 37.336379, lng: -121.881285)!
        
        let photo5 = UIImage(named: "BBC")!
        let building5 = BuildingMarker(name: "BBC", photo: photo5,
            address: "Boccardo Business Complex, San Jose, CA 95112",
            lat: 37.336665, lng: -121.878752)!
        
        let photo6 = UIImage(named: "SouthParkingGarage")!
        let building6 = BuildingMarker(name: "South Parking Garage", photo: photo6,
            address: "San Jose State University South Garage, 330 South 7th Street, San Jose, CA 95112",
            lat: 37.333134, lng: -121.880838)!
        
        buildingMarkers += [building1, building2, building3, building4, building5, building6]
    }
    
    /* -------------------------------- UIScrollViewDelegate -------------------------------- */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, buildingMarker) in buildingMarkers.enumerate() {
            let offset = CoordinateToScrollViewOffset(CLLocation(latitude: buildingMarker.lat, longitude: buildingMarker.lng))
            let buildingButton = buildingMarker.button!
            let buildingLabel = buildingMarker.label!
            buildingButton.frame.size = CGSize(width: 25, height: 25)
            buildingButton.frame.origin = CGPoint(x: offset.x - buildingButton.frame.width  / 2, y: offset.y - buildingButton.frame.height / 2)
            buildingButton.tag = index
            buildingLabel.sizeToFit()
            buildingLabel.frame.origin = CGPoint(x: offset.x - buildingLabel.frame.width / 2, y: offset.y + buildingButton.frame.size.height / 2)
        }
        
        imageView.bringSubviewToFront(locationMaker)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func CoordinateToScrollViewOffset(location: CLLocation) -> CGPoint {
        
        let scrollViewSize = scrollView.frame.size
        let imageSize = imageView.image!.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let scale = min(widthScale, heightScale)
        
        let verticalPadding = imageSize.height * scale < scrollViewSize.height ? (scrollViewSize.height - imageSize.height * scale) / 2 : 0
        let horizontalPadding = imageSize.width * scale < scrollViewSize.width ? (scrollViewSize.width - imageSize.width * scale) / 2 : 0
        
        let a = campusTopLeft.distanceFromLocation(location)
        let b = campusTopRight.distanceFromLocation(location)
        let c = campusBottomLeft.distanceFromLocation(location)
        let d = campusBottomRight.distanceFromLocation(location)
        let e = campusTopLeft.distanceFromLocation(campusTopRight)
        let f = campusTopLeft.distanceFromLocation(campusBottomLeft)
        
        var p = (a + b + e) / 2;
        let areaTriangleTop = sqrt(p * (p - a) * (p - b) * (p - e));
        p = (c + d + e) / 2;
        let areaTriangleBottom = sqrt(p * (p - c) * (p - d) * (p - e));
        p = (a + c + f) / 2;
        let areaTriangleLeft = sqrt(p * (p - a) * (p - c) * (p - f));
        p = (b + d + f) / 2;
        let areaTriangleRight = sqrt(p * (p - b) * (p - d) * (p - f));
        let x = CGFloat(areaTriangleLeft / (areaTriangleLeft + areaTriangleRight)) * imageSize.width * scale + horizontalPadding
        let y = CGFloat(areaTriangleTop / (areaTriangleTop + areaTriangleBottom)) * imageSize.height * scale + verticalPadding
        
        return CGPointMake(x, y)
    }
    
    
    /* -------------------------------- CLLocationManagerDelegate -------------------------------- */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Alert: Failed to get your location, Please enable it in settings
        print("Failed to get your location, Please enable it in settings")
        locationMaker.hidden = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = manager.location!.coordinate
        if (userLocation != nil) {
            print("GPS Location = \(userLocation!.latitude) \(userLocation!.longitude)")
            
            let campusRange: CGMutablePathRef = CGPathCreateMutable()
            var points = [CGPoint]()
            for location in [campusTopLeft, campusTopRight, campusBottomLeft, campusBottomRight] {
                points.append(CGPointMake(CGFloat(location.coordinate.longitude), CGFloat(location.coordinate.latitude)))
            }
            
            CGPathAddLines(campusRange, nil, points, 4)
            CGPathCloseSubpath(campusRange)
            if (CGPathContainsPoint(campusRange, nil, CGPointMake(CGFloat(userLocation!.longitude), CGFloat(userLocation!.latitude)), true)) {
                let makerOffset = CoordinateToScrollViewOffset(CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude))
                locationMaker.frame = CGRect(origin: makerOffset, size: locationMaker.frame.size)
                locationMaker.hidden = false
            }
            //            locationManager.stopUpdatingLocation()
        }
    }
    
    /* -------------------------------- Button Action -------------------------------- */
    @IBAction func buttonClick(sender: UIButton!) {
        let buildingMarker = buildingMarkers[sender.tag]
        let detailBuildingVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailBuildingVC") as! DetailBuildingViewController
        detailBuildingVC.buildingMarker = buildingMarker
        
        // MapService
        if (userLocation != nil) {
            let mapService = MapService()
            let userLocationString = String(userLocation!.latitude) + "," + String(userLocation!.longitude)
            let buildingLocationString = String(buildingMarker.lat) + "," + String(buildingMarker.lng)
            let mapServiceResponse = mapService.distancetime(userLocationString, destination: buildingLocationString)
            
            detailBuildingVC.timeString = "Time: " + String(mapServiceResponse["time"]!)
            detailBuildingVC.distanceString = "Distance: " + String(mapServiceResponse["distance"]!)
        }
        
        self.presentViewController(detailBuildingVC, animated: true, completion: nil)
    }
    
    /* ------------------------------------- search ------------------------------------- */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var result = [BuildingMarker]()
 
        for buildingMaker in buildingMarkers {
            if (buildingMaker.name.lowercaseString.hasPrefix(searchText.lowercaseString)) {
                result.append(buildingMaker)
            }
        }
        
        if (result.count == 1) {
            let buildingOrigin = result[0].button!.frame.origin
            let offset = CGPoint(x: buildingOrigin.x * scrollView.zoomScale - scrollView.frame.size.width / 2,
                y: buildingOrigin.y * scrollView.zoomScale - scrollView.frame.size.height / 2)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
}

