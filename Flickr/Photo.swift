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
	
	let remoteURLs: (
		smallImageURL: NSURL,
		largeImageURL: NSURL
	)
	
	let ownerID: String?
}

extension Photo {
	init?(dictionary: JSONDictionary) {
		guard let
			photoID = dictionary["id"] as? String,
			title = dictionary["title"] as? String,
			smallImageURLString = dictionary["url_m"] as? String,
			ownerID = dictionary["owner"] as? String,
			smallImageURL = NSURL(string: smallImageURLString) else { return nil }
		
		if let
			largeImageURLString = dictionary["url_h"] as? String,
			largeImageURL = NSURL(string: largeImageURLString) {
			self.remoteURLs = (smallImageURL, largeImageURL)
		} else {
			let originalImageURLString = dictionary["url_m"] as! String
			let originalImageURL = NSURL(string: originalImageURLString)!
			self.remoteURLs = (smallImageURL, originalImageURL)
		}
		
		self.ownerID = ownerID
		self.photoID = photoID
		self.title = title
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
