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
	
	init(webservice: Webservice, bigViewModel: BigViewModel, oauthService: OAuthService) {
		self.sharedWebservice = webservice
		self.bigViewModel = bigViewModel
		self.sharedOAuthService = oauthService
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
}
