//
//  PhotoTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
@testable import Flickr

class PhotoTests: XCTestCase {
	
	var dict = ["isfamily": 0,
	            "owner": "129341115@N05",
	            "title": "Coal Harbour",
	            "url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
	            "width_h": 1600,
	            "width_m": 500,
	            "ispublic": 1,
	            "url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
	            "farm": 9,
	            "height_m": 333,
	            "url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
	            "id": "28657740294",
	            "server": 8470,
	            "height_z": 427,
	            "secret": "a49413b15c",
	            "width_z": 640,
	            "isfriend": 0,
	            "height_h": 1068
	]
	
	func testIfPhotoParses() {
		let photo = Photo(dictionary: dict)
		XCTAssertNotNil(photo)
	}
	
	func testIfPhotoParsesCorrectly() {
		let photo = Photo(dictionary: dict)
		
		XCTAssertEqual(photo?.ownerID, dict["owner"] as? String)
		XCTAssertEqual(photo?.photoID, dict["id"] as? String)
		XCTAssertEqual(photo?.title, dict["title"] as? String)
		
		let smallImageURL = NSURL(string: dict["url_m"] as! String)
		let largeImageURL = NSURL(string: dict["url_h"] as! String)
		
		XCTAssertEqual(photo?.smallImageURL, smallImageURL)
		XCTAssertEqual(photo?.largeImageURL, largeImageURL)
	}
	
	func testIfNoHImage() {
		dict.removeValueForKey("url_h")
		let photo = Photo(dictionary: dict)
		
		let largeImageURL = NSURL(string: dict["url_z"] as! String)
		
		XCTAssertEqual(photo?.largeImageURL, largeImageURL)
	}
	
	func testIfNoLargeImages() {
		dict.removeValueForKey("url_h")
		dict.removeValueForKey("url_z")
		let photo = Photo(dictionary: dict)
		
		XCTAssertNil(photo!.largeImageURL)
	}
	
	func testIfNoSmallImage() {
		dict.removeValueForKey("url_m")
		let photo = Photo(dictionary: dict)
		
		XCTAssertNil(photo)
	}

}
