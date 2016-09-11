//
//  ProfileViewModelTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 11/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class ProfileViewModelTests: XCTestCase {
	
	let container = Container { c in
		c.register(StateViewModel.self) { _ in StateViewModel() }
		c.register(Networking.self) { _ in MockWebservice() }
		
		c.register(ProfileViewModel.self) { r in
			ProfileViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				webservice: r.resolve(Networking.self)!
			)
		}
	}
	
	var photoDict = [
		"owner": "129341115@N05",
		"title": "Coal Harbour",
		"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
		"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
		"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
		"id": "28657740294"
	]
	
	var viewModel: ProfileViewModel!

    override func setUp() {
        super.setUp()
        viewModel = container.resolve(ProfileViewModel.self)!
		
		viewModel.stateViewModel.currentPhoto = Photo(dictionary: photoDict)
    }
	
	func testIfLoadsProfile() {
		XCTAssertNil(viewModel.profile)
		viewModel.loadProfile {}
		XCTAssertNotNil(viewModel.profile)
		
	}
	
	func testIfLoadsPhotos() {
		XCTAssertTrue(viewModel.photos.isEmpty)
		viewModel.loadPhotos {}
		XCTAssertFalse(viewModel.photos.isEmpty)
	}
	
	func testIfSetsCurrentPhoto() {
		photoDict["id"] = "123456789"
		viewModel.stateViewModel.currentPhoto = Photo(dictionary: photoDict)
		viewModel.loadPhotos {}
		XCTAssertNotEqual(viewModel.photos[0], viewModel.stateViewModel.currentPhoto)
		viewModel.setCurrentPhoto(0)
		XCTAssertEqual(viewModel.photos[0], viewModel.stateViewModel.currentPhoto)
	}

}
