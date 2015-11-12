//
//  ViewController.swift
//  SJSU Interactive Map
//
//  Created by Liping on 11/10/15.
//  Copyright © 2015 Liping. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btn: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "campusmap")
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        
        
        print("---viewDidLoad---")
        print("image.size", imageView.image!.size)
        print("imageView.size", imageView.frame.size)
        print("scrollView.frame.size", scrollView.frame.size)
        print("scrollView.contentSize", scrollView.contentSize)
        print("screen.size", UIScreen.mainScreen().bounds.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("---viewDidLayoutSubviews---")
        print("image.size", imageView.image!.size)
        print("imageView.size", imageView.frame.size)
        print("scrollView.frame.size", scrollView.frame.size)
        print("scrollView.contentSize", scrollView.contentSize)
        print("screen.size", UIScreen.mainScreen().bounds.size)
        
        
        btn.backgroundColor = UIColor.redColor()
        btn1.backgroundColor = UIColor.redColor()
        btn2.backgroundColor = UIColor.redColor()
        btn3.backgroundColor = UIColor.redColor()
        
        let scrollViewSize = scrollView.frame.size
        let imageSize = imageView.image!.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let scale = min(widthScale, heightScale)
        print("scale", scale)
        
        let verticalPadding = imageSize.height * scale < scrollViewSize.height ? (scrollViewSize.height - imageSize.height * scale) / 2 : 0
        let horizontalPadding = imageSize.width * scale < scrollViewSize.width ? (scrollViewSize.width - imageSize.width * scale) / 2 : 0
        
        print("padding", verticalPadding, horizontalPadding)
        
        let location = CLLocation(latitude: 37.332449, longitude: -121.882248)
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
        
//        print("x", CGFloat(areaTriangleX / (areaQuadrangle / 2)) * imageSize.width * scale)
//        print("y", CGFloat(areaTriangleY / (areaQuadrangle / 2)) * imageSize.height * scale)
//        let x = CGFloat(areaTriangleX / (areaQuadrangle / 2)) * imageSize.width * scale + horizontalPadding
//        let y = CGFloat(areaTriangleY / (areaQuadrangle / 2)) * imageSize.height * scale + verticalPadding
        
        
        btn.frame = CGRect(origin: CGPointMake(x, y), size: btn.frame.size)
//        btn1.frame = CGRect(origin: CGPointMake(200 * scale, 200 * scale + verticalPadding), size: btn.frame.size)
//        btn2.frame = CGRect(origin: CGPointMake(167 * scale, 218 * scale + verticalPadding), size: btn.frame.size)
//        btn3.frame = CGRect(origin: CGPointMake(650 * scale, 690 * scale + verticalPadding), size: btn.frame.size)
        
        print("==== origin ====", btn.frame.origin)
        
        //        let offset = latlngToViewXY(scrollViewSize, location: CLLocation(latitude: 37.336859, longitude: -121.882154))
        //        print("offset", offset)
        
        
        //        let offset = latlngToCampusImageCoordinate(CLLocation(latitude: 37.337074, longitude: -121.881648))
        
        //        let markerImageView = UIImageView(image: UIImage(named: "marker"))
        //        markerImageView.frame.offsetInPlace(dx: offset.x, dy: offset.y)
        //        imageView.addSubview(markerImageView)
        
        //        btn.frame.offsetInPlace(dx: offset.x, dy: offset.y)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func latlngToViewPosition(location: CLLocation) -> CGPoint {
        
        let scrollViewSize = scrollView.frame.size
        let imageSize = imageView.image!.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let scale = min(widthScale, heightScale)
        print("scale", scale)
        
        let verticalPadding = imageSize.height * scale < scrollViewSize.height ? (scrollViewSize.height - imageSize.height * scale) / 2 : 0
        let horizontalPadding = imageSize.width * scale < scrollViewSize.width ? (scrollViewSize.width - imageSize.width * scale) / 2 : 0
        
        print("padding", verticalPadding, horizontalPadding)
        
        let campusTopLeft = CLLocation(latitude: 37.337161, longitude: -121.887881)
        let campusTopRight = CLLocation(latitude: 37.340737, longitude: -121.880252)
        let campusBottomLeft = CLLocation(latitude: 37.330761, longitude: -121.883152)
        let campusBottomRight = CLLocation(latitude: 37.334337, longitude: -121.875502)
        
        let a = campusTopLeft.distanceFromLocation(location)
        let b = campusTopRight.distanceFromLocation(location)
        let c = campusTopLeft.distanceFromLocation(campusBottomLeft)
        let d = campusBottomRight.distanceFromLocation(campusBottomLeft)
        let p = (a + b + c) / 2;
        let areaTriangleX = sqrt(p * (p - a) * (p - b) * (p - c));
        let areaTriangleY = sqrt(p * (p - a) * (p - b) * (p - d));
        let areaQuadrangle = c * d
        
        print("x", CGFloat(areaTriangleX / (areaQuadrangle / 2)) * imageSize.width)
        let x = CGFloat(areaTriangleX / (areaQuadrangle / 2)) * imageSize.width * scale + horizontalPadding
        let y = CGFloat(areaTriangleY / (areaQuadrangle / 2)) * imageSize.height * scale + verticalPadding
        return CGPointMake(x, y)
    }
    
}

