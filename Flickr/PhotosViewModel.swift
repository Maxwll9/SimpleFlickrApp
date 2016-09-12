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
	
	private var allPhotos = [
		[Photo](),
		[Photo]()
	]
	
	private var selectedIndex = 0 {
		didSet {
			if (selectedIndex < 0) || (selectedIndex >= allPhotos.count) {
				selectedIndex = oldValue
			}
		}
	}
	
	private var urls = [
		FlickrURL.getInterestingPhotosURL(),
		FlickrURL.getRecentPhotosURL()
	]
	
	var photos: [Photo] {
		return allPhotos[selectedIndex]
	}
	
	init(stateViewModel: StateViewModel, webservice: Networking, oauthService: AuthNetworking) {
		self.stateViewModel = stateViewModel
		self.sharedWebservice = webservice
		self.sharedOAuthService = oauthService
	}
}

// MARK: - Load methods
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
	
}


// MARK: - Setting methods
extension PhotosViewModel {
	func setCurrentPhoto(index: Int) {
		if index >= photos.count { return }
		stateViewModel.currentPhoto = allPhotos[selectedIndex][index]
	}
	
	func changeSegment(selectedIndex: Int, completion: () -> ()) {
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
