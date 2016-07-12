//
//  Profile.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

struct Profile {
	let userName: String
	let realName: String?
	let userID: String
	
	let location: String?
	let buddyIconURL: NSURL
}

extension Profile {
	init?(dictionary: JSONDictionary) {
		guard let
			id = dictionary["id"] as? String,
			userName = (dictionary["username"] as? JSONDictionary)?["_content"] as? String
			else { return nil }
		
		if let
			iconFarm = dictionary["iconfarm"] as? Int where iconFarm > 0,
			let nsid = dictionary["nsid"] as? String,
			iconServer = dictionary["iconserver"] as? String {
				self.buddyIconURL = FlickrURL.getBuddyiconURL(iconFarm, iconServer: iconServer, nsid: nsid)
		} else {
			self.buddyIconURL = NSURL(string: "https://www.flickr.com/images/buddyicon.gif")!
		}
		
		self.location = (dictionary["location"] as? JSONDictionary)?["_content"] as? String
		self.realName = (dictionary["realname"] as? JSONDictionary)?["_content"] as? String
		
		self.userName = userName
		self.userID = id
	}
}

extension Profile {
	static func resource(url: NSURL) -> Resource<Profile> {
		return Resource<Profile>(url: url) { json in
			guard let person = json["person"] as? JSONDictionary else { return nil }
			
			return self.init(dictionary: person)
		}
	}
}
