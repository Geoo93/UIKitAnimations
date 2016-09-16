//
//  Blurable.swift
//  StorySmarties
//
//  Created by Daniel Asher on 17/05/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//  iOS 9 ONLY.

import Foundation
import UIKit

protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    
    func addSubview(view: UIView)
    func removeFromSuperview()
    
    func blur(blurRadius blurRadius: CGFloat) -> BlurOverlay?
    func unBlur()
    
    var isBlurred: Bool { get }
}

extension Blurable
{
    func blur(blurRadius blurRadius: CGFloat) -> BlurOverlay?
    {
        if self.superview == nil
        {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
  
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur"),
            this = self as? UIView else
        {
            return nil
        }
  
        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        let result = blur.valueForKey(kCIOutputImageKey) as! CIImage!
        
        let boundingRect = CGRect(x:0,
            y: 0,
            width: frame.width,
            height: frame.height)
        
        let cgImage = ciContext.createCGImage(result, fromRect: boundingRect)

        let filteredImage = UIImage(CGImage: cgImage)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = UIViewContentMode.Left
     
        self.addSubview(blurOverlay)
        
//        if #available(iOS 9.0, *) {
//            if let superview = superview as? UIStackView,
//                index = (superview as UIStackView).arrangedSubviews.indexOf(this)
//            {
//                removeFromSuperview()
//                superview.insertArrangedSubview(blurOverlay, atIndex: index)
//            }
//            else
//            {
//                blurOverlay.frame.origin = frame.origin
//                
//                UIView.transitionFromView(this,
//                                          toView: blurOverlay,
//                                          duration: 0.2,
//                                          options: UIViewAnimationOptions.CurveEaseIn,
//                                          completion: nil)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        objc_setAssociatedObject(this,
            &BlurableKey.blurable,
            blurOverlay,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return blurOverlay
    }
    
    func unBlur()
    {
        guard let this = self as? UIView,
            blurOverlay = objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) as? BlurOverlay else
        {
            return
        }
        
//        if #available(iOS 9.0, *) {
//            if let superview = blurOverlay.superview as? UIStackView,
//                index = (blurOverlay.superview as! UIStackView).arrangedSubviews.indexOf(blurOverlay)
//            {
//                blurOverlay.removeFromSuperview()
//                superview.insertArrangedSubview(this, atIndex: index)
//            }
//            else
//            {
//                this.frame.origin = blurOverlay.frame.origin
//                
//                UIView.transitionFromView(blurOverlay,
//                                          toView: this,
//                                          duration: 0.2,
//                                          options: UIViewAnimationOptions.CurveEaseIn,
//                                          completion: nil)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        objc_setAssociatedObject(this,
            &BlurableKey.blurable,
            nil,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    var isBlurred: Bool
    {
        return objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) is BlurOverlay
    }
}

extension UIView: Blurable
{
}

class BlurOverlay: UIImageView
{
}

struct BlurableKey
{
    static var blurable = "blurable"
}
