//
//  Network.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Alamofire
import Nuke

public typealias JSONDictionary = [String: AnyObject]

protocol Networking {
	func load<A>(resource: Resource<A>, completion: A? -> ())
}

extension Networking {
	func loadImage(url: NSURL, completion: ((Image?) -> ())) {
		Nuke.taskWith(url) { result in
			if case let.Success(image, _) = result {
				completion(image)
			}
		}.resume()
	}
}

class Webservice: Networking {
	func load<A>(resource: Resource<A>, completion: A? -> ()) {
		Alamofire.request(.GET, resource.url).responseData { response in
			let data = response.data
			let result = data.flatMap(resource.parse)
			completion(result)
		}
	}
}

import OAuthSwift

protocol AuthNetworking {
	func toggleAuth(vc: UIViewController, successHandler: (Bool) ->())
	func addComment(photoID: String, text: String, completion: (Bool) -> ())
}

class OAuthService {
	private let APIKey = "50bf07aafa817f50d769007471816e84"
	private let secret = "188c8a3c9fa1e9a4"
	private let baseURLString = "https://www.flickr.com/services/oauth/"
	
	private var oauthswift: OAuth1Swift?
	
	private func authorize(vc: UIViewController, successHandler: (() -> ())) {
		let requestTokenURLString = baseURLString + "request_token"
		let authorizeURLString = baseURLString + "authorize"
		let accessTokenURLString = baseURLString + "access_token"
		
		let oauthswift = OAuth1Swift(
			consumerKey: APIKey,
			consumerSecret: secret,
			requestTokenUrl: requestTokenURLString,
			authorizeUrl: authorizeURLString,
			accessTokenUrl: accessTokenURLString
		)
		
		oauthswift.authorize_url_handler = SafariURLHandler(viewController: vc)
		
		oauthswift.authorizeWithCallbackURL(
			NSURL(string: "com.NasakinMaxim.Flickr://oauthCallback")!,
			success: { credential, response, parameters in
				print("SUCCESS")
				successHandler()
			}, failure: { error in
				print(error.localizedDescription)
			}
		)
		
		self.oauthswift = oauthswift
	}
}

extension OAuthService: AuthNetworking {
	func toggleAuth(vc: UIViewController, successHandler: (Bool) -> ()) {
		if let _ = oauthswift {
			oauthswift = nil
			successHandler(false)
		} else {
			authorize(vc) {
				successHandler(true)
			}
		}
	}
	
	func addComment(photoID: String, text: String, completion: (Bool) -> ()) {
		let urlString = FlickrURL.addCommentURLString(photoID, text: text)
		
		oauthswift?.client.post(
			urlString,
			success: { data, response in
				print("COMMENTED!")
				completion(true)
		}) { error in
			print(error)
			completion(false)
		}
	}
}
