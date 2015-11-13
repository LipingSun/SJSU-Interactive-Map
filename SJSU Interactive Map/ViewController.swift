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
    var buildings = [Building]()
    
    // ScrollView
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // CLLocationManagerDelegate
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Building data
        loadBuildings()
        for building in buildings {
            let button = UIButton()
            button.setTitle(building.name, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("buttonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            building.button = button
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
        
        // MapService
        let mapService = MapService()
        var result = mapService.distancetime("37.3369726,-121.8824186", destination: "37.333736,-121.8805341")
        print("distance", result["distance"])
        print("time", result["time"])
        
        // Search
        searchBar.delegate = self
    }
    
    
    /* -------------------------------- Building data -------------------------------- */
    func loadBuildings() {
        let photo1 = UIImage(named: "KingLibrary")!
        let building1 = Building(name: "King Library", photo: photo1,
            address: "150 E San Fernando St, San Jose, CA 95112", lat: 37.335491, lng: -121.885141)!
        
        let photo2 = UIImage(named: "EngineeringBuilding")!
        let building2 = Building(name: "Engineering Building", photo: photo2,
            address: "San José State University Charles W. Davidson College of Engineering, 1 Washington Square, San Jose, CA 95112", lat: 37.337098, lng: -121.881831)!
        
        let photo3 = UIImage(named: "YoshihiroUchidaHall")!
        let building3 = Building(name: "Yoshihiro Uchida Hall", photo: photo3,
            address: "Yoshihiro Uchida Hall, San Jose, CA 95112",
            lat: 37.333658, lng: -121.883880)!
        
        let photo4 = UIImage(named: "StudentUnion")!
        let building4 = Building(name: "Student Union", photo: photo4,
            address: "Student Union Building, San Jose, CA 95112",
            lat: 37.336379, lng: -121.881285)!
        
        let photo5 = UIImage(named: "BBC")!
        let building5 = Building(name: "BBC", photo: photo5,
            address: "Boccardo Business Complex, San Jose, CA 95112",
            lat: 37.336665, lng: -121.878752)!
        
        let photo6 = UIImage(named: "SouthParkingGarage")!
        let building6 = Building(name: "South Parking Garage", photo: photo6,
            address: "San Jose State University South Garage, 330 South 7th Street, San Jose, CA 95112",
            lat: 37.333134, lng: -121.880838)!
        
        buildings += [building1, building2, building3, building4, building5, building6]
    }
    
    /* -------------------------------- UIScrollViewDelegate -------------------------------- */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        let location = CLLocation(latitude: 37.332449, longitude: -121.882248)
        for (index, building) in buildings.enumerate() {
            let btnOffset = CLLocation(latitude: building.lat, longitude: building.lng)
            building.button!.frame = CGRect(origin: CoordinateToScrollViewOffset(btnOffset), size: CGSize(width: 46, height: 30))
            building.button!.tag = index
        }
        
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
        
        let campusTopLeft = CLLocation(latitude: 37.337161, longitude: -121.887881)
        let campusTopRight = CLLocation(latitude: 37.340737, longitude: -121.880252)
        let campusBottomLeft = CLLocation(latitude: 37.330761, longitude: -121.883152)
        let campusBottomRight = CLLocation(latitude: 37.334337, longitude: -121.875502)
        
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
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("GPS Location = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
    /* -------------------------------- Button Action -------------------------------- */
    @IBAction func buttonClick(sender: UIButton!) {
        let building = buildings[sender.tag]
        let detailBuildingVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailBuildingVC") as! DetailBuildingViewController
        detailBuildingVC.nameString = building.name
        detailBuildingVC.addressString = building.address
        detailBuildingVC.photoImage = building.photo
        detailBuildingVC.timeString = building.time
        detailBuildingVC.distanceString = building.distance
        self.presentViewController(detailBuildingVC, animated: true, completion: nil)
    }
    
    /* ------------------------------------- search ------------------------------------- */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for building in buildings{
            if(building.name.lowercaseString ==  searchBar.text!.lowercaseString){
                let buildingOrigin = building.button!.frame.origin
                let offset = CGPoint(x: buildingOrigin.x * scrollView.zoomScale - scrollView.frame.size.width / 2,
                    y: buildingOrigin.y * scrollView.zoomScale - scrollView.frame.size.height / 2)
                scrollView.setContentOffset(offset, animated: true)
            }
        }
    }
    
}

