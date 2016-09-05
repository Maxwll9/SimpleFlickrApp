//
//  ProfileTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
@testable import Flickr

class ProfileTests: XCTestCase {
	
	var dict = [
		"nsid": "78621811@N06",
		"realname": [
			"_content": "Albert Dros"
		],
		"location": [
			"_content": "Netherlands, Netherlands"
		],
		"username": [
			"_content": "albert dros"
		],
		"iconfarm": 8,
		"id": "78621811@N06",
		"iconserver": "7259",
	]
	
	func testIfProfileParses() {
		let profile = Profile(dictionary: dict)
		XCTAssertNotNil(profile)
	}
	
	func testIfProfileDoesntParse() {
		dict.removeValueForKey("id")
		let profile = Profile(dictionary: dict)
		XCTAssertNil(profile)
	}
	
	func testIfProfilePassesCorrectly() {
		let profile = Profile(dictionary: dict)
		
		XCTAssertEqual(profile?.buddyIconURL, FlickrURL.getBuddyiconURL(dict))
		XCTAssertNotEqual(profile?.buddyIconURL, FlickrURL.defaultBuddyIconURL)
		XCTAssertEqual(profile?.userID, dict["id"] as? String)
		
		let username = (dict["username"] as? JSONDictionary)?["_content"] as? String
		let realname = (dict["realname"] as? JSONDictionary)?["_content"] as? String
		let location = (dict["location"] as? JSONDictionary)?["_content"] as? String
		
		XCTAssertEqual(profile?.userName, username)
		XCTAssertEqual(profile?.realName, realname)
		XCTAssertEqual(profile?.location, location)
	}
	
	func testIfNoRealname() {
		dict.removeValueForKey("realname")
		let profile = Profile(dictionary: dict)
		XCTAssertNil(profile?.realName)
	}
	
	func testIfNoLocation() {
		dict.removeValueForKey("location")
		let profile = Profile(dictionary: dict)
		XCTAssertNil(profile?.location)
	}
	
	func testIfNoPersonalBuddyIcon() {
		dict["iconfarm"] = 0
		let profile = Profile(dictionary: dict)
		
		XCTAssertEqual(profile?.buddyIconURL, FlickrURL.getBuddyiconURL(dict))
		XCTAssertEqual(profile?.buddyIconURL, FlickrURL.defaultBuddyIconURL)
	}

}
