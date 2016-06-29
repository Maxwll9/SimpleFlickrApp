//
//  PhotosDetailViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Nuke

class PhotoDetailViewModel {
	
	var photo: Photo!
	var comments = [Comment]()
	
	func loadComments(completion: (() -> ())?) {
		let url = FlickrURL.getCommentsForPhoto(photo.photoID)

		Webservice.load(Comment.all(url)) { result in
			if let result = result {
				self.comments = result
			}
			completion?()
		}
	}
}
