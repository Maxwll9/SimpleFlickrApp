//
//  PhotoDetailViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

class PhotoDetailViewModel {
	
	var sharedWebservice: Webservice
	
	var photo: Photo!
	var comments = [Comment]()
	
	init(webservice: Webservice) {
		self.sharedWebservice = webservice
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
}
