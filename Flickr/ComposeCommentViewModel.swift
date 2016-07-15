//
//  ComposeCommentViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

class ComposeCommentViewModel {
	
	let stateViewModel: StateViewModel
	private let sharedOAuthService: OAuthService
	
	var didSent = false
	
	init(stateViewModel: StateViewModel, sharedOAuthService: OAuthService) {
		self.stateViewModel = stateViewModel
		self.sharedOAuthService = sharedOAuthService
	}
	
	func addComment(text: String, completion: (Bool) -> ()) {
		sharedOAuthService.addComment(stateViewModel.currentPhoto.photoID, text: text) { [weak self] result in
			self?.didSent = result
			completion(result)
		}
	}
}
