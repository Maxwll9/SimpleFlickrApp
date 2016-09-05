//
//  CommentTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
@testable import Flickr

class CommentTests: XCTestCase {

	var dict = [
		"authorname": "John Doe",
		"_content": "Great stuff!",
		"author": "23456789",
		"iconserver": "123",
		"iconfarm": 1
	]
	
	func testIfCommentParses() {
		let comment = Comment(dictionary: dict)
		
		XCTAssertEqual(comment?.authorID, dict["author"] as? String)
		XCTAssertEqual(comment?.authorName, dict["authorname"] as? String)
		XCTAssertEqual(comment?.content, dict["_content"] as? String)
		
		XCTAssertEqual(comment?.buddyIconURL, FlickrURL.getBuddyiconURL(dict))
		XCTAssertNotEqual(comment?.buddyIconURL, FlickrURL.defaultBuddyIconURL)
	}
	
	func testIfNoPersonalBuddyIcon() {
		dict["iconfarm"] = 0
		let comment = Comment(dictionary: dict)
		
		XCTAssertEqual(comment?.buddyIconURL, FlickrURL.getBuddyiconURL(dict))
		XCTAssertEqual(comment?.buddyIconURL, FlickrURL.defaultBuddyIconURL)
	}
	
}
