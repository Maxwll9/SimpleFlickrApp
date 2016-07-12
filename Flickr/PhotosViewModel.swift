//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotosViewModel {
	
	let bigViewModel: BigViewModel
	let sharedWebservice: Webservice
	let sharedOAuthService: OAuthService
	
	var selectedIndex = 0
	var photos = [
		[Photo](),
		[Photo]()
	]
	var urls = [
		FlickrURL.getInterestingPhotosURL(),
		FlickrURL.getRecentPhotosURL()
	]
	
	init(webservice: Webservice, bigViewModel: BigViewModel, sharedOAuthService: OAuthService) {
		self.sharedWebservice = webservice
		self.bigViewModel = bigViewModel
		self.sharedOAuthService = sharedOAuthService
	}
	
	func loadPhotos(completion: (() -> ())?) {
		sharedWebservice.load(Photo.all(urls[selectedIndex])) { [weak self] result in
			if let result = result {
				self?.photos[self!.selectedIndex] = result
			}
			completion?()
		}
	}
	
	func setCurrentPhoto(index: Int) {
		bigViewModel.currentPhoto = photos[selectedIndex][index]
	}
	
	func authorize(vc: UIViewController, successHandler: (() -> ())) {
		if let _ = sharedOAuthService.oauthswift {
			sharedOAuthService.oauthswift = nil
			bigViewModel.isAuthorized = false
			successHandler()
		} else {
			sharedOAuthService.authorize(vc) { [weak self] in
				self?.bigViewModel.isAuthorized = true
				successHandler()
			}
		}
	}
}
