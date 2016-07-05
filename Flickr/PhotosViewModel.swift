//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

class PhotosViewModel {
	
	var sharedWebservice: Webservice

	var photos = [Photo]()
	
	var url = FlickrURL.getInterestingPhotosURL()
	
	init(webservice: Webservice) {
		self.sharedWebservice = webservice
	}
	
	func loadPhotos(completion: (() -> ())?) {
		sharedWebservice.load(Photo.all(url)) { [weak self] result in
			if let result = result {
				self?.photos = result
			}
			completion?()
		}
	}
}
