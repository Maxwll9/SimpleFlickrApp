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
		c.register(AuthNetworking.self) { _ in OAuthService() }
		
		c.register(ComposeCommentViewModel.self) { r in
			ComposeCommentViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				oauthService: r.resolve(AuthNetworking.self)!
			)
		}
	}
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

}
