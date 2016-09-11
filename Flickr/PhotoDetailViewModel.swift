//
//  PhotoDetailViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

final class PhotoDetailViewModel {
	
	let stateViewModel: StateViewModel
	private let sharedWebservice: Networking
	
	var photo: Photo {
		return stateViewModel.currentPhoto
	}
	
	var comments = [Comment]()
	
	init(stateViewModel: StateViewModel, webservice: Networking) {
		self.stateViewModel = stateViewModel
		self.sharedWebservice = webservice
	}
}

extension PhotoDetailViewModel {
	func loadComments(completion: (() -> ())?) {
		let url = FlickrURL.getCommentsForPhoto(photo.photoID)
		
		sharedWebservice.load(Comment.all(url)) { [weak self] result in
			if let result = result {
				self?.comments = result
			}
			completion?()
		}
	}
	
	func loadImage(completion: (UIImage?) -> ()) {
		let largeImageURL = photo.largeImageURL
		let smallImageURL = photo.smallImageURL
		sharedWebservice.loadImage(largeImageURL ?? smallImageURL, completion: completion)
	}
	
	func loadBuddyIcon(index: Int, completion: (UIImage?) -> ()) {
		let url = comments[index].buddyIconURL
		sharedWebservice.loadImage(url, completion: completion)
	}
}
