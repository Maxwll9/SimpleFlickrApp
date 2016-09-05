//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotosViewModel {
	
	let stateViewModel: StateViewModel
	let sharedWebservice: Webservice
	private let sharedOAuthService: OAuthService
	
	var selectedIndex = 0
	var photos = [
		[Photo](),
		[Photo]()
	]
	var urls = [
		FlickrURL.getInterestingPhotosURL(),
		FlickrURL.getRecentPhotosURL()
	]
	
	init(webservice: Webservice, stateViewModel: StateViewModel, sharedOAuthService: OAuthService) {
		self.sharedWebservice = webservice
		self.stateViewModel = stateViewModel
		self.sharedOAuthService = sharedOAuthService
	}
}

extension PhotosViewModel {
	func photo(index: Int) -> Photo {
		return photos[selectedIndex][index]
	}
	
	func loadPhotos(completion: () -> ()) {
		sharedWebservice.load(Photo.all(urls[selectedIndex])) { [weak self] result in
			if let result = result {
				self?.photos[self!.selectedIndex] = result
			}
			completion()
		}
	}
	
	func setCurrentPhoto(index: Int) {
		stateViewModel.currentPhoto = photos[selectedIndex][index]
	}
	
	func changeSegment(selectedIndex: Int, completion: () -> ()) {
		self.selectedIndex = selectedIndex
		
		if photos[selectedIndex].isEmpty {
			loadPhotos(completion)
		} else {
			completion()
		}
	}
	
	func toggleAuthorize(vc: UIViewController, successHandler: (() -> ())) {
		sharedOAuthService.toggleAuth(vc) { [weak self] isAuthorized in
			self?.stateViewModel.isAuthorized = isAuthorized
			successHandler()
		}
	}
}
