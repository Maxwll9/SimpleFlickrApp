//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

class PhotosViewModel {
	
	let sharedWebservice: Webservice
	let bigViewModel: BigViewModel

	var photos = [Photo]()
	
	var url = FlickrURL.getInterestingPhotosURL()
	
	init(webservice: Webservice, bigViewModel: BigViewModel) {
		self.sharedWebservice = webservice
		self.bigViewModel = bigViewModel
	}
	
	func loadPhotos(completion: (() -> ())?) {
		sharedWebservice.load(Photo.all(url)) { [weak self] result in
			if let result = result {
				self?.photos = result
			}
			completion?()
		}
	}
	
	func setCurrentPhoto(index: Int) {
		bigViewModel.currentPhoto = photos[index]
	}
}
