//
//  Photo.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

struct Photo {
	let photoID: String
	let title: String
	
	let remoteURL: NSURL
	
	let ownerID: String?
}

extension Photo {
	init?(dictionary: JSONDictionary) {
		guard let
			photoID = dictionary["id"] as? String,
			title = dictionary["title"] as? String,
			remoteURLString = dictionary["url_b"] as? String,
			ownerID = dictionary["owner"] as? String,
			remoteURL = NSURL(string: remoteURLString) else { return nil }
		
		self.ownerID = ownerID
		self.photoID = photoID
		self.title = title
		self.remoteURL = remoteURL
	}
}

extension Photo {
	static func all(url: NSURL) -> Resource<[Photo]> {
		let resource = Resource<[Photo]>(url: url) { json in
			guard let
				jsonPhotos = json["photos"] as? JSONDictionary,
				dictionaries = jsonPhotos["photo"] as? [JSONDictionary] else { return nil }
			
			return dictionaries.flatMap(Photo.init)
		}
		
		return resource
	}
}
