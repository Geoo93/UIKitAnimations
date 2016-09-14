//
//  UISearchController+RxTests.swift
//  Rx
//
//  Created by Segii Shulga on 3/17/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)
    
import Foundation
import RxSwift
import RxCocoa
import XCTest
import UIKit

class UISearchController_RxTests: RxTest {
    
    func testDidDismissSearchController() {
        var completed = false
        var didDismissed = false
        
        autoreleasepool {
            let searchController = UISearchController()
            
            _ = searchController.rx_didDismiss
                .subscribe(onNext: {
                        didDismissed = true
                    }, onCompleted: {
                        completed = true
                })
            searchController.delegate!.didDismissSearchController!(searchController)
        }
        
        XCTAssertTrue(completed)
        XCTAssertTrue(didDismissed)
    }
 
    func testDidPresentSearchController() {
        var completed = false
        var didPresent = false
        
        autoreleasepool {
            let searchController = UISearchController()
            
            _ = searchController.rx_didPresent
                .subscribe(onNext: {
                    didPresent = true
                    }, onCompleted: {
                        completed = true
                })
            searchController.delegate!.didPresentSearchController!(searchController)
        }
        
        XCTAssertTrue(completed)
        XCTAssertTrue(didPresent)
    }
    
    func testPresentSearchController() {
        var completed = false
        var presented = false
        
        autoreleasepool {
            let searchController = UISearchController()
            
            _ = searchController.rx_present
                .subscribe(onNext: {
                    presented = true
                    }, onCompleted: {
                        completed = true
                })
            searchController.delegate!.presentSearchController!(searchController)
        }
        
        XCTAssertTrue(completed)
        XCTAssertTrue(presented)
    }
    
    func testWillDismissSearchController() {
        var completed = false
        var willDismiss = false
        
        autoreleasepool {
            let searchController = UISearchController()
            
            _ = searchController.rx_willDismiss
                .subscribe(onNext: {
                    willDismiss = true
                    }, onCompleted: {
                        completed = true
                })
            searchController.delegate!.willDismissSearchController!(searchController)
        }
        
        XCTAssertTrue(completed)
        XCTAssertTrue(willDismiss)
    }
    
    func testWillPresentSearchController() {
        var completed = false
        var willPresent = false
        
        autoreleasepool {
            let searchController = UISearchController()
            
            _ = searchController.rx_willPresent
                .subscribe(onNext: {
                    willPresent = true
                    }, onCompleted: {
                        completed = true
                })
            searchController.delegate!.willPresentSearchController!(searchController)
        }
        
        XCTAssertTrue(completed)
        XCTAssertTrue(willPresent)
    }
    
}

#endif
