//
//  AppDelegate.swift
//  Flickr
//
//  Created by Maxim Nasakin on 11/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		OAuthSwift.handleOpenURL(url)
		UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
		return true
	}
}

