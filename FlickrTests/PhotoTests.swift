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
	
	var dict = [
		"owner": "129341115@N05",
		"title": "Coal Harbour",
		"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
		"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
		"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
		"id": "28657740294"
	]
	
	func testIfPhotoParses() {
		let photo = Photo(dictionary: dict)
		XCTAssertNotNil(photo)
	}
	
	func testIfPhotoParsesCorrectly() {
		let photo = Photo(dictionary: dict)
		
		XCTAssertEqual(photo?.ownerID, dict["owner"])
		XCTAssertEqual(photo?.photoID, dict["id"])
		XCTAssertEqual(photo?.title, dict["title"])
		
		let smallImageURL = NSURL(string: dict["url_m"]!)
		let largeImageURL = NSURL(string: dict["url_h"]!)
		
		XCTAssertEqual(photo?.smallImageURL, smallImageURL)
		XCTAssertEqual(photo?.largeImageURL, largeImageURL)
	}
	
	func testIfNoHImage() {
		dict.removeValueForKey("url_h")
		let photo = Photo(dictionary: dict)
		
		let largeImageURL = NSURL(string: dict["url_z"]!)
		
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
