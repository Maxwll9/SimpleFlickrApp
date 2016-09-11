//
//  Comment.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

struct Comment {
	let authorName: String
	let authorID: String
	let content: String
	
	let buddyIconURL: NSURL
}

extension Comment {
	init?(dictionary: JSONDictionary) {
		guard let
			authorName = dictionary["authorname"] as? String,
			content = dictionary["_content"] as? String,
			author = dictionary["author"] as? String else { return nil }
		
		self.buddyIconURL = FlickrURL.getBuddyiconURL(dictionary)
		
		self.authorName = authorName
		self.authorID = author
		self.content = content
	}
}

extension Comment {
	static func all(url: NSURL) -> Resource<[Comment]> {
		return Resource<[Comment]>(url: url) { json in
			guard let
				jsonComments = json["comments"] as? JSONDictionary,
				dictionaries = jsonComments["comment"] as? [JSONDictionary] else { return nil }
			
			return dictionaries.flatMap(Comment.init)
		}
	}
}

extension Comment: Equatable {}

func ==(lhs: Comment, rhs: Comment) -> Bool {
	return lhs.authorID == rhs.authorID
}
