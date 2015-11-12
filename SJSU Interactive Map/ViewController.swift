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
        
        let scrollViewSize = scrollView.frame.size
        let imageSize = imageView.image!.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let scale = min(widthScale, heightScale)
        print("scale", scale)
        
        let verticalPadding = imageSize.height * scale < scrollViewSize.height ? (scrollViewSize.height - imageSize.height * scale) / 2 : 0
        let horizontalPadding = imageSize.width * scale < scrollViewSize.width ? (scrollViewSize.width - imageSize.width * scale) / 2 : 0
        
        print("padding", verticalPadding, horizontalPadding)
        btn.backgroundColor = UIColor.redColor()
        btn.frame = CGRect(origin: CGPoint(x: 0 * scale + horizontalPadding, y: 0 * scale + verticalPadding), size: btn.frame.size)

        
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
    
    func latlngToViewPosition(scrollViewSize: CGSize, location: CLLocation) -> CGPoint {
        let campusTopLeft = CLLocation(latitude: 37.337161, longitude: -121.887881)
        let campusTopRight = CLLocation(latitude: 37.340737, longitude: -121.880252)
        let campusBottomLeft = CLLocation(latitude: 37.330761, longitude: -121.883152)
        let campusBottomRight = CLLocation(latitude: 37.334337, longitude: -121.875502)
        
        let x = scrollViewSize.width * CGFloat((location.coordinate.longitude - campusTopLeft.coordinate.longitude) / (campusBottomRight.coordinate.longitude - campusTopLeft.coordinate.longitude))
        let y = scrollViewSize.height * CGFloat((campusTopRight.coordinate.latitude - location.coordinate.latitude) / (campusTopRight.coordinate.latitude - campusBottomLeft.coordinate.latitude))
        return CGPointMake(x, y)
    }
    
}

