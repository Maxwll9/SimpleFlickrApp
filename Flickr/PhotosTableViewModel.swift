//
//  PhotosTableViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Nuke

class PhotosViewModel {
	
	
	var photos = [Photo]()
	
	func loadPhotos(completion: (() -> ())?) {
		let url = FlickrURL.getInterestingPhotosURL()
		
		Webservice.load(Photo.all(url)) { result in
			if let result = result {
				self.photos = result
			}
			completion?()
		}
	}
}
