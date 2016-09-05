//
//  PhotoDetailViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoDetailViewModel {
	
	let stateViewModel: StateViewModel
	private let sharedWebservice: Webservice
	
	var photo: Photo {
		return stateViewModel.currentPhoto
	}
	
	var comments = [Comment]()
	
	init(webservice: Webservice, stateViewModel: StateViewModel) {
		self.sharedWebservice = webservice
		self.stateViewModel = stateViewModel
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
	
	func cellForRow(cell: CommentTableViewCell, indexPathRow row: Int) {
		let comment = comments[row]
		
		cell.configure(comment)
		
		cell.tag = row
		
		cell.buddyIconImageView.image = nil
		
		loadBuddyIcon(row) { image in
			guard
				cell.tag == row,
				let image = image else { return }
			
			cell.buddyIconImageView.image = image
			
			UIView.animateWithDuration(0.2) {
				cell.buddyIconImageView.alpha = 1
			}
		}
	}
}
