//
//  ProfileTableViewControllerTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 11/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class ProfileTableViewControllerTests: XCTestCase {

	let container = Container { c in
		let dict = [
			"owner": "129341115@N05",
			"title": "Coal Harbour",
			"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
			"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
			"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
			"id": "28657740294"
		]
		
		c.register(StateViewModel.self) { _ in
			let vm = StateViewModel()
			vm.currentPhoto = Photo(dictionary: dict)
			return vm
		}
		c.register(Networking.self) { _ in MockWebservice() }
		
		c.register(ProfileViewModel.self) { r in
			ProfileViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				webservice: r.resolve(Networking.self)!
			)
		}
	}
	
	var vc: ProfileTableViewController!
	
	override func setUp() {
		super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		
		vc = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileTableViewController
		vc.viewModel = container.resolve(ProfileViewModel.self)!
		
		UIApplication.sharedApplication().keyWindow!.rootViewController = vc
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate())
		
		let _ = vc.view
	}
	
	func testIfLoadsProfileRight() {
		let dict = [
			"id": "129341115@N05",
			"nsid": "129341115@N05",
			"iconserver": "7516",
			"iconfarm": 8,
			"username": [
				"_content": "WestEndFoto"
			],
			"realname": [
				"_content": "WestEndFoto"
			],
			"location": [
				"_content": "Vancouver, Canada"
			]
		]
		
		let profile = Profile(dictionary: dict)
		
		XCTAssertEqual(vc.usernameLabel.text, profile?.realName)
		XCTAssertEqual(vc.locationLabel.text, profile?.location)
	}
}
