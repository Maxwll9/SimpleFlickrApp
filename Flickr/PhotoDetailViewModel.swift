//
//  PhotoDetailViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoDetailViewModel {
	
	let sharedWebservice: Webservice
	let bigViewModel: BigViewModel
	
	var photo: Photo {
		return bigViewModel.currentPhoto
	}
	
	var comments = [Comment]()
	
	init(webservice: Webservice, bigViewModel: BigViewModel) {
		self.sharedWebservice = webservice
		self.bigViewModel = bigViewModel
	}
	
	func loadComments(completion: (() -> ())?) {
		let url = FlickrURL.getCommentsForPhoto(photo.photoID)

		sharedWebservice.load(Comment.all(url)) { [weak self] result in
			if let result = result {
				self?.comments = result
			}
			completion?()
		}
	}
	
	func loadImage(imageView: UIImageView, completion: (() -> ())?) {
		let url = photo.remoteURLs.largeImageURL
		sharedWebservice.loadImage(imageView, url: url, completion: completion)
	}
}
