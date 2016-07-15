//
//  SwinjectStoryboard+Setup.swift
//  Flickr
//
//  Created by Maxim Nasakin on 02/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Swinject

extension SwinjectStoryboard {
	static func setup() {
		let stateViewModel = StateViewModel()
		let oauthService = OAuthService()
		
		defaultContainer.register(Webservice.self) { _ in Webservice() }
		
		// MARK: PhotosTableViewController
		defaultContainer.register(PhotosViewModel.self) { r in
			PhotosViewModel(
				webservice: r.resolve(Webservice.self)!,
				stateViewModel: stateViewModel,
				sharedOAuthService: oauthService
			)
		}
		
		defaultContainer.registerForStoryboard(PhotosTableViewController.self) { r, c in
			c.viewModel = r.resolve(PhotosViewModel.self)!
		}
		
		// MARK: PhotoDetailTableViewController
		defaultContainer.register(PhotoDetailViewModel.self) { r in
			PhotoDetailViewModel(
				webservice: r.resolve(Webservice.self)!,
				stateViewModel: stateViewModel
			)
		}
		
		defaultContainer.registerForStoryboard(PhotoDetailTableViewController.self) { r, c in
			c.viewModel = r.resolve(PhotoDetailViewModel.self)!
		}
		
		// MARK: ComposeCommentViewController
		defaultContainer.register(ComposeCommentViewModel.self) { _ in
			ComposeCommentViewModel(
				stateViewModel: stateViewModel,
				sharedOAuthService: oauthService
			)
		}
		
		defaultContainer.registerForStoryboard(ComposeCommentViewController.self) { r, c in
			c.viewModel = r.resolve(ComposeCommentViewModel.self)!
		}
		
		// MARK: ProfileTableViewController
		defaultContainer.register(ProfileViewModel.self) { r in
			ProfileViewModel(
				webservice: r.resolve(Webservice.self)!,
				stateViewModel: stateViewModel
			)
		}
		
		defaultContainer.registerForStoryboard(ProfileTableViewController.self) { r, c in
			c.viewModel = r.resolve(ProfileViewModel.self)!
		}
		
	}
}
