//
//  ComposeCommentViewModelTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class ComposeCommentViewModelTests: XCTestCase {
	
	let container = Container { c in
		c.register(StateViewModel.self) { _ in StateViewModel() }
		c.register(AuthNetworking.self) { _ in MockOAuthService() }
		
		c.register(ComposeCommentViewModel.self) { r in
			ComposeCommentViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				oauthService: r.resolve(AuthNetworking.self)!
			)
		}
	}
	
	var viewModel: ComposeCommentViewModel!
	
    override func setUp() {
        super.setUp()
		
		let dict = [
			"owner": "129341115@N05",
			"title": "Coal Harbour",
			"url_z": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c_z.jpg",
			"url_m": "https://farm9.staticflickr.com/8470/28657740294_a49413b15c.jpg",
			"url_h": "https://farm9.staticflickr.com/8470/28657740294_467c065280_h.jpg",
			"id": "28657740294"
		]
		
		let photo = Photo(dictionary: dict)
		
		viewModel = container.resolve(ComposeCommentViewModel.self)!
		viewModel.stateViewModel.currentPhoto = photo
    }
	
	func testIfDidSendSets() {
		XCTAssertFalse(viewModel.didSend)
		
		viewModel.addComment("") { result in
			XCTAssertTrue(self.viewModel.didSend)
		}
	}

}
