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
	
	let dict = [
		"owner": "129341115@N05",
		"title": "Coal Harbour",
		"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
		"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
		"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
		"id": "28657740294"
	]
	
	var vc: PhotosTableViewController!
	
	override func setUp() {
		super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		
		vc = storyboard.instantiateViewControllerWithIdentifier("Photos") as! PhotosTableViewController
		vc.viewModel = container.resolve(PhotosViewModel.self)!
		
		UIApplication.sharedApplication().keyWindow!.rootViewController = vc
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate())
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
	
	func testIfTableViewHasRightPhotos() {
		let photo = Photo(dictionary: dict)
		
		vc.viewDidLoad()
		
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		let cell = vc.tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		
		XCTAssertEqual(cell.titleLabel.text, photo?.title)
	}
}
