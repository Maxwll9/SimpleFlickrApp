//
//  ProfileViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class ProfileViewModel {
	let sharedWebservice: Webservice
	
	var photos = [Photo]()
	var profile: Profile!
	
	var userID: String!
	
	init(webservice: Webservice) {
		self.sharedWebservice = webservice
	}
	
	func loadPhotos(completion: (() -> ())?) {
		let url = FlickrURL.getPublicPhotosForUser(userID)
		sharedWebservice.load(Photo.all(url)) { [weak self] result in
			if let result = result {
				self?.photos = result
			}
			completion?()
		}
	}
	
	func loadProfile(completion: (() -> ())?) {
		let url = FlickrURL.getProfileInfo(userID)
		sharedWebservice.load(Profile.resource(url)) { [weak self] result in
			if let result = result {
				self?.profile = result
				completion?()
			}
		}
	}
	
	func loadBuddyIcon(imageView: UIImageView, completion: (() -> ())? ) {
		sharedWebservice.loadImage(imageView, url: profile.buddyiconURL, completion: completion)
	}
}
