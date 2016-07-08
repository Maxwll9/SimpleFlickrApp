//
//  BigViewModel.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

class BigViewModel {
	let defaultBuddyIconURL = NSURL(string: "https://www.flickr.com/images/buddyicon.gif")!
	
	var currentPhoto: Photo!
	var isProfile = false
	var isAuthorized = false
}
