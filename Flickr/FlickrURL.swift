//
//  FlickrURL.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

enum Method: String {
	case InterestingPhotos = "flickr.interestingness.getList"
	
	case RecentPhotos = "flickr.photos.getRecent"
	case GetComments = "flickr.photos.comments.getList"
	
	case GetPublicPhotos = "flickr.people.getPublicPhotos"
	case GetProfileInfo = "flickr.people.getInfo"
}

struct FlickrURL {
	private static let baseURLString = "https://api.flickr.com/services/rest"
	private static let APIKey = "50bf07aafa817f50d769007471816e84"
	
	private static func flickrURL(method method: Method, parameters: [String: String]?) -> NSURL {
		let components = NSURLComponents(string: baseURLString)!
		
		var queryItems = [NSURLQueryItem]()
		
		let baseParameters = [
			"method": method.rawValue,
			"format": "json",
			"nojsoncallback": "1",
			"api_key": APIKey
		]
		
		queryItems += baseParameters.flatMap { key, value in
			NSURLQueryItem(name: key, value: value)
		}
		
		if let additionalParams = parameters {
			queryItems += additionalParams.flatMap { key, value in
				NSURLQueryItem(name: key, value: value)
			}
		}
		
		components.queryItems = queryItems
		
		return components.URL!
	}
	
	static func getRecentPhotosURL() -> NSURL {
		return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_m,url_h,url_z,owner"])
	}
	
	static func getInterestingPhotosURL() -> NSURL {
		return flickrURL(method: .InterestingPhotos, parameters: ["extras": "url_m,url_h,url_z,owner"])
	}
	
	static func getCommentsForPhoto(photoID: String) -> NSURL {
		return flickrURL(method: .GetComments, parameters: ["photo_id": photoID])
	}
	
	static func getProfileInfo(ownerID: String) -> NSURL {
		let params = [
			"user_id": ownerID
		]
		return flickrURL(method: .GetProfileInfo, parameters: params)
	}
	
	static func getPublicPhotosForUser(ownerID: String) -> NSURL {
		let params = [
			"user_id": ownerID,
			"extras": "url_m,url_h,date_taken"
		]
		return flickrURL(method: .GetPublicPhotos, parameters: params)
	}
	
	static func getBuddyiconURL(iconFarm: Int, iconServer: String, nsid: String) -> NSURL {
		let urlString = "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsid).jpg"
		return NSURL(string: urlString)!
	}
}
