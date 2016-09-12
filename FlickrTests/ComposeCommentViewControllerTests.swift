//
//  ComposeCommentViewControllerTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 12/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class ComposeCommentViewControllerTests: XCTestCase {
	
	let container = Container { c in
		let dict = [
			"owner": "129341115@N05",
			"title": "Coal Harbour",
			"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
			"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
			"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
			"id": "28657740294"
		]
		
		c.register(StateViewModel.self) { _ in
			let vm = StateViewModel()
			vm.currentPhoto = Photo(dictionary: dict)
			vm.isAuthorized = true
			return vm
		}
		c.register(AuthNetworking.self) { _ in MockOAuthService() }
		
		c.register(ComposeCommentViewModel.self) { r in
			ComposeCommentViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				oauthService: r.resolve(AuthNetworking.self)!
			)
		}
	}
	
	var vc: ComposeCommentViewController!

    override func setUp() {
        super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		vc = storyboard.instantiateViewControllerWithIdentifier("ComposeComment") as! ComposeCommentViewController
		vc.viewModel = container.resolve(ComposeCommentViewModel.self)!

		UIApplication.sharedApplication().keyWindow!.rootViewController = vc
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate())
		let _ = vc.view
    }

	func testIfDidSendComment() {
		XCTAssertFalse(vc.viewModel.didSent)
		
		vc.commentTextView.text = "Sample text"
		vc.sendComment(vc)
		XCTAssertTrue(vc.viewModel.didSent)
	}

}
