//
//  ComposeCommentViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

final class ComposeCommentViewModel {
	
	let stateViewModel: StateViewModel
	private let sharedOAuthService: OAuthService
	
	var didSent = false
	
	init(stateViewModel: StateViewModel, oauthService: OAuthService) {
		self.stateViewModel = stateViewModel
		self.sharedOAuthService = oauthService
	}
}

extension ComposeCommentViewModel {
	func addComment(text: String, completion: (Bool) -> ()) {
		sharedOAuthService.addComment(stateViewModel.currentPhoto.photoID, text: text) { [weak self] result in
			self?.didSent = result
			completion(result)
		}
	}
}
