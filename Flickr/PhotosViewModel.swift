//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

final class PhotosViewModel {
	
	let stateViewModel: StateViewModel
	private let sharedWebservice: Networking
	private let sharedOAuthService: AuthNetworking
	
	private var selectedIndex = 0
	private var allPhotos = [
		[Photo](),
		[Photo]()
	]
	
	private var urls = [
		FlickrURL.getInterestingPhotosURL(),
		FlickrURL.getRecentPhotosURL()
	]
	
	var photos: [Photo] {
		return allPhotos[selectedIndex]
	}
	
	init(webservice: Networking, stateViewModel: StateViewModel, oauthService: AuthNetworking) {
		self.stateViewModel = stateViewModel
		self.sharedWebservice = webservice
		self.sharedOAuthService = oauthService
	}
}

extension PhotosViewModel {
	
	func loadPhotos(completion: () -> ()) {
		let url = urls[selectedIndex]
		let resource = Photo.all(url)
		sharedWebservice.load(resource) { [weak self] result in
			if let result = result {
				self?.allPhotos[self!.selectedIndex] = result
			}
			completion()
		}
	}
	
	func loadImage(index: Int, completion: (UIImage?) -> ()) {
		let url = photos[index].smallImageURL
		sharedWebservice.loadImage(url, completion: completion)
	}
	
	func setCurrentPhoto(index: Int) {
		stateViewModel.currentPhoto = allPhotos[selectedIndex][index]
	}
	
	func changeSegment(selectedIndex: Int, completion: () -> ()) {
		if (selectedIndex != 0) && (selectedIndex != 1) { return }
		
		self.selectedIndex = selectedIndex
		
		if allPhotos[selectedIndex].isEmpty {
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
