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
	let content: String
}

extension Comment {
	init?(dictionary: JSONDictionary) {
		guard let
			authorName = dictionary["authorname"] as? String,
			content = dictionary["_content"] as? String else { return nil }
		
		self.authorName = authorName
		self.content = content
	}
}

extension Comment {
	static func all(url: NSURL) -> Resource<[Comment]> {
		let resource = Resource<[Comment]>(url: url) { json in
			guard let
				jsonComments = json["comments"] as? JSONDictionary,
				dictionaries = jsonComments["comment"] as? [JSONDictionary] else { return nil }
			
			return dictionaries.flatMap(Comment.init)
		}
		
		return resource
	}
}
