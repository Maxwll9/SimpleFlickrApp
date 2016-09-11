//
//  PhotoDetailViewModelTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class PhotoDetailViewModelTests: XCTestCase {
	
	let container = Container { c in
		c.register(StateViewModel.self) { _ in StateViewModel() }
		c.register(Networking.self) { _ in MockWebservice() }
		
		c.register(PhotoDetailViewModel.self) { r in
			PhotoDetailViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				webservice: r.resolve(Networking.self)!
			)
		}
	}
	
	var viewModel: PhotoDetailViewModel!
	
    override func setUp() {
        super.setUp()
		
		viewModel = container.resolve(PhotoDetailViewModel.self)!
		
		let dict = [
			"owner": "129341115@N05",
			"title": "Coal Harbour",
			"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
			"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
			"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
			"id": "28657740294"
		]
		
		let photo = Photo(dictionary: dict)
		
		viewModel.stateViewModel.currentPhoto = photo
    }
	
	func testIfLoadsComments() {
		XCTAssertTrue(viewModel.comments.isEmpty)
		viewModel.loadComments {}
		XCTAssertFalse(viewModel.comments.isEmpty)
	}
	
	func testIfLoadsCommentsRight() {
		let dict = [
			"authorname": "johndoe",
			"_content": "Great stuff!",
			"author": "1232325235325"
		]
		
		let comment = Comment(dictionary: dict)!
		viewModel.loadComments {}
		
		XCTAssertEqual(viewModel.comments[0], comment)
	}

}
