//
//  PhotosViewModelTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 06/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class PhotosViewModelTests: XCTestCase {
	
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
		
		func load<A>(resource: Resource<A>, completion: A? -> ()) {
			let data = try? NSJSONSerialization.dataWithJSONObject(photosDict, options: .PrettyPrinted)
			let result = data.flatMap(resource.parse)
			completion(result)
		}
		
		func loadImage(url: NSURL, completion: ((UIImage?) -> ())) {
			let image = UIImage()
			completion(image)
		}
	}
	
	let container = Container { c in
		c.register(StateViewModel.self) { _ in StateViewModel() }
		c.register(Networking.self) { _ in MockWebservice() }
		c.register(AuthNetworking.self) { _ in OAuthService() }
		
		c.register(PhotosViewModel.self) { r in
			PhotosViewModel(
				webservice: c.resolve(Networking.self)!,
				stateViewModel: c.resolve(StateViewModel.self)!,
				oauthService: c.resolve(AuthNetworking.self)!
			)
		}
	}
	
	var viewModel: PhotosViewModel!
	
	override func setUp() {
		super.setUp()

		viewModel = container.resolve(PhotosViewModel.self)!
	}
	
	func testIfLoadsPhotos() {
		XCTAssertTrue(viewModel.photos.isEmpty)
		viewModel.loadPhotos {}
		XCTAssertFalse(viewModel.photos.isEmpty)
	}
	
	func testIfSetsCurrentPhotoRight() {
		viewModel.loadPhotos {}
		viewModel.setCurrentPhoto(0)
		let photosPhoto = viewModel.photos[0]
		let statePhoto = viewModel.stateViewModel.currentPhoto
		
		XCTAssertEqual(photosPhoto, statePhoto)
	}
}
