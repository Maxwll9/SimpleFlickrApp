//
//  ProfileViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class ProfileViewModel {
	
	let stateViewModel: StateViewModel
	let sharedWebservice: Webservice
	
	var photos = [Photo]()
	var profile: Profile!
	
	var userID: String {
		return stateViewModel.currentPhoto.ownerID
	}
	
	init(webservice: Webservice, stateViewModel: StateViewModel) {
		self.sharedWebservice = webservice
		self.stateViewModel = stateViewModel
	}
}


extension ProfileViewModel {
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
	
	func loadBuddyIcon(completion: ((UIImage?) -> ())) {
		sharedWebservice.loadImage(profile.buddyIconURL, completion: completion)
	}
	
	func setCurrentPhoto(index: Int) {
		stateViewModel.currentPhoto = photos[index]
	}
}
