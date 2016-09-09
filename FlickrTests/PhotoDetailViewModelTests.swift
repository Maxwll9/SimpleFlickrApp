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
	
	class MockWebservice: Networking {
		private let dict = [
			"comments": [
				"comment": [[
					"author": "127997011@N03",
					"iconfarm": 1,
					"id": "57843817-28896665993-72157672483226161",
					"realname": "Räi",
					"iconserver": 663,
					"_content": "Wow incredible capture... [https://www.flickr.com/photos/57866871@N03/]",
					"authorname": "Räi"
				]]
			]
		]
		
		func load<A>(resource: Resource<A>, completion: A? -> ()) {
			let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
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
		
		c.register(PhotoDetailViewModel.self) { r in
			PhotoDetailViewModel(
				webservice: r.resolve(Networking.self)!,
				stateViewModel: r.resolve(StateViewModel.self)!
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

}
