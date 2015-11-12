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
    
    // ScrollView
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btn: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ScrollView
        imageView.image = UIImage(named: "campusmap")
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        
        btn.backgroundColor = UIColor.redColor()
        btn1.backgroundColor = UIColor.redColor()
        btn2.backgroundColor = UIColor.redColor()
        btn3.backgroundColor = UIColor.redColor()
    }
    
    /* --------------------------------  UIScrollViewDelegate -------------------------------- */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("---viewDidLayoutSubviews---")
        print("image.size", imageView.image!.size)
        print("imageView.size", imageView.frame.size)
        print("scrollView.frame.size", scrollView.frame.size)
        print("scrollView.contentSize", scrollView.contentSize)
        print("screen.size", UIScreen.mainScreen().bounds.size)
        
        
        let location = CLLocation(latitude: 37.332449, longitude: -121.882248)
        btn.frame = CGRect(origin: CoordinateToScrollViewOffset(location), size: btn.frame.size)
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
    
    
    
}

