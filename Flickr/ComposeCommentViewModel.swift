//
//  ComposeCommentViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

class ComposeCommentViewModel {
	
	let bigViewModel: BigViewModel
	let sharedOAuthService: OAuthService
	
	var didSent = false
	
	init(bigViewModel: BigViewModel, sharedOAuthService: OAuthService) {
		self.bigViewModel = bigViewModel
		self.sharedOAuthService = sharedOAuthService
	}
	
	func addComment(text: String, completion: (Bool) -> ()) {
		sharedOAuthService.addComment(bigViewModel.currentPhoto.photoID, text: text, completion: completion)
	}
}
