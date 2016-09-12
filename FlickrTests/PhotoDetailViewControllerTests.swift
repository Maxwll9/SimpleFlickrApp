//
//  PhotoDetailViewControllerTests.swift
//  Flickr
//
//  Created by Maxim Nasakin on 11/09/2016.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import XCTest
import UIKit
import Swinject
@testable import Flickr

class PhotoDetailViewControllerTests: XCTestCase {
	
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
			return vm
		}
		c.register(Networking.self) { _ in MockWebservice() }
		
		c.register(PhotoDetailViewModel.self) { r in
			PhotoDetailViewModel(
				stateViewModel: r.resolve(StateViewModel.self)!,
				webservice: r.resolve(Networking.self)!
			)
		}
	}
	
	var vc: PhotoDetailTableViewController!

    override func setUp() {
        super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
		
		vc = storyboard.instantiateViewControllerWithIdentifier("PhotoDetail") as! PhotoDetailTableViewController
		vc.viewModel = container.resolve(PhotoDetailViewModel.self)!
		
		UIApplication.sharedApplication().keyWindow!.rootViewController = vc
		
		NSRunLoop.mainRunLoop().runUntilDate(NSDate())
		
		let _ = vc.view
    }
	
	func testIfComposeButtonWorks() {
		XCTAssertFalse(vc.composeBarButtonItem.enabled)
		vc.viewModel.stateViewModel.isAuthorized = true
		vc.viewDidLoad()
		XCTAssertTrue(vc.composeBarButtonItem.enabled)
	}
	
	func testIfLoadsComments() {
		vc.refresh()
		XCTAssertFalse(vc.viewModel.comments.isEmpty)
	}
	
	func testIfLoadsCommentsRight() {
		let dict = [
			"authorname": "johndoe",
			"_content": "Great stuff!",
			"author": "1232325235325"
		]
		
		let comment = Comment(dictionary: dict)
		
		vc.refresh()
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		let cell = vc.tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
		XCTAssertEqual(cell.nameLabel.text, comment?.authorName)
		XCTAssertEqual(cell.commentLabel.text, comment?.content)
	}
	
	func testIfNumberOfRowsIsRight() {
		let numberOfRows = vc.tableView(vc.tableView, numberOfRowsInSection: 0)
		XCTAssertEqual(numberOfRows, vc.viewModel.comments.count)
	}

	func testIfRefreshControlNotNil() {
		XCTAssertNotNil(vc.refreshControl)
	}
}
