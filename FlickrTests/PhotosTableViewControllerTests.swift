//
//  PhotosTableViewControllerTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 11/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class PhotosTableViewControllerTests: XCTestCase {
	
	let container = Container { c in
		c.register(StateViewModel.self) { _ in StateViewModel() }
		c.register(Networking.self) { _ in MockWebservice() }
		c.register(AuthNetworking.self) { _ in MockOAuthService() }
		
		c.register(PhotosViewModel.self) { r in
			PhotosViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				webservice: r.resolve(Networking.self)!,
				oauthService: r.resolve(AuthNetworking.self)!
			)
		}
	}
	
	var vc: PhotosTableViewController!
	
	override func setUp() {
		super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
		
		vc = navigationController.topViewController as! PhotosTableViewController
		vc.viewModel = container.resolve(PhotosViewModel.self)!
		
		UIApplication.sharedApplication().keyWindow!.rootViewController = vc
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate())
		let _ = navigationController.view
		let _ = vc.view
	}
	
	func testIfChangesSegmentedControl() {
		vc.segmentedControl.selectedSegmentIndex = 1
		vc.segmentedControlDidChange(vc)
		vc.viewModel.changeSegment(1) {}
		XCTAssertTrue(!vc.viewModel.photos.isEmpty)
	}
	
	func testIfAuthButtonUpdates() {
		let userOutline = UIImage(named: "userOutline")
		let userFilled = UIImage(named: "userFilled")
		
		XCTAssertEqual(vc.authorizeBarButtonItem.image, userOutline)
		vc.authButtonDidPress(vc)
		XCTAssertEqual(vc.authorizeBarButtonItem.image, userFilled)
	}
}
