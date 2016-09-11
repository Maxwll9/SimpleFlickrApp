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
	
	class MockWebservice: Networking {
		
		private let photosDict = [
			"photos": [
				"photo": [[
					"owner": "129341115@N05",
					"title": "Coal Harbour",
					"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
					"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
					"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
					"id": "28657740294"
				]]
			]
		]
		
		private let profileDict = [
			"person": [
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
		]
		
		func load<A>(resource: Resource<A>, completion: A? -> ()) {
			let type = "\(A.self)"
			let dict = (type == "Profile") ? profileDict : photosDict
			
			let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
			let result = data.flatMap(resource.parse)
			completion(result)
		}
	}
	
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
	
	var viewModel: ProfileViewModel!

    override func setUp() {
        super.setUp()
        viewModel = container.resolve(ProfileViewModel.self)!
		
		let photoDict = [
			"owner": "129341115@N05",
			"title": "Coal Harbour",
			"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
			"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
			"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
			"id": "28657740294"
		]
		
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

}
