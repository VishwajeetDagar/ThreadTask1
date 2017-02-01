//
//  ImageLoading.swift
//  ThreadApp1
//
//  Created by Vishwajeet Dagar on 2/1/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension UIImageView {
    func getimage(url: URL, cell: TableViewCell, animateIndicator: Bool) -> Operation? {
        var indicator: UIActivityIndicatorView? = nil
        if animateIndicator == true{
            indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            if #available(iOS 9.0, *) {
                indicator!.centerXAnchor.constraint(equalTo: (superview?.centerXAnchor)!)
                indicator!.centerYAnchor.constraint(equalTo: (superview?.centerYAnchor)!)
            } else {
                indicator?.center = self.center
            }
            indicator!.startAnimating()
            cell.addSubview(indicator!)
            indicator!.isHidden = false
        }
        var operation1: Operation? = nil
        if (cache.object(forKey: url as AnyObject) != nil){
            cell.img.image = cache.object(forKey: url as AnyObject) as? UIImage
            if indicator != nil{
                indicator!.stopAnimating()
                indicator!.isHidden = true
            }
        }
        else{
            operation1 = loadImage(url: url, cell: cell,indicator: indicator)
        }
        return operation1
    }
    
    
    func loadImage(url: URL, cell: TableViewCell, indicator: UIActivityIndicatorView?)->Operation?{
        let operation1 = BlockOperation(block:{
            let data = try? Data(contentsOf: url)
            let img1 = UIImage(data: data!)
            cache.setObject(img1!, forKey: url as AnyObject)
            DispatchQueue.main.async {
                if indicator != nil{
                    indicator!.stopAnimating()
                    indicator!.isHidden = true
                }
                cell.img.image=img1
            }
        })
        return operation1
    }
}
