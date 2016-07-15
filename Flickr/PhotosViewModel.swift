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
	
	init(webservice: Webservice, stateViewModel: StateViewModel, sharedOAuthService: OAuthService) {
		self.sharedWebservice = webservice
		self.stateViewModel = stateViewModel
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
		stateViewModel.currentPhoto = photos[selectedIndex][index]
	}
	
	func toggleAuthorize(vc: UIViewController, successHandler: (() -> ())) {
		sharedOAuthService.toggleAuth(vc) { [weak self] isAuthorized in
			self?.stateViewModel.isAuthorized = isAuthorized
			successHandler()
		}
	}
	
	func cellForRow(cell: PhotoTableViewCell, indexPathRow row: Int) {
		let photo = photos[selectedIndex][row]
		let photoURL = photo.remoteURLs.smallImageURL
		
		cell.tag = row
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = photo.title
		cell.spinner.startAnimating()
		
		sharedWebservice.loadImage(photoURL) { image in
			if cell.tag == row {
				cell.photoImageView.image = image
				cell.spinner.stopAnimating()
				
				UIView.animateWithDuration(1) {
					cell.photoImageView.alpha = 1
				}
			}
		}
	}
}
