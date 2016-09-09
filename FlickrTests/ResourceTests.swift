//
//  ResourceTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
@testable import Flickr

class ResourceTests: XCTestCase {

	func testIfURLIsRight() {
		let url = FlickrURL.getInterestingPhotosURL()
		let resource = Photo.all(url)
		
		XCTAssertEqual(resource.url, url)
	}

}
