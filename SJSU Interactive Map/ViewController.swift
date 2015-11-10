//
//  ViewController.swift
//  SJSU Interactive Map
//
//  Created by Liping on 11/10/15.
//  Copyright © 2015 Liping. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "campusmap")
        scrollView.contentSize = imageView.image!.size
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        
//        print(imageViewSize.height, imageViewSize.width, scrollViewSize.height, scrollViewSize.width)
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let scale = min(widthScale, heightScale)
        
        scrollView.zoomScale = scale
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 2
        
        //        print(imageViewSize.height * scale, imageViewSize.width * scale)
        
        let verticalPadding = imageViewSize.height * scale < scrollViewSize.height ?
            (scrollViewSize.height - imageViewSize.height * scale) / 2 : 0
        let horizontalPadding = imageViewSize.width * scale < scrollViewSize.width ?
            (scrollViewSize.width - imageViewSize.width * scale) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding,
            bottom: verticalPadding, right: horizontalPadding)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }


}

