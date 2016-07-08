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

class Webservice {
	var test: Int!
	
	func load<A>(resource: Resource<A>, completion: A? -> ()) {
		Alamofire.request(.GET, resource.url).responseData { response in
			let result = response.data.flatMap(resource.parse)
			completion(result)
		}
	}
	
	func loadImage(url: NSURL, completion: ((Image) -> ())?) {
		Nuke.taskWith(url) { result in
			if case let.Success(image, _) = result {
				completion?(image)
			}
		}.resume()
	}
}

import OAuthSwift

enum CommentCompletion {
	case Success
	case Failure(ErrorType)
}

class OAuthService {
	private var oauthswift: OAuth1Swift?
	
	func authorize() {
		let APIKey = "50bf07aafa817f50d769007471816e84"
		let secret = "188c8a3c9fa1e9a4"
		
		let requestTokenURLString = "https://www.flickr.com/services/oauth/request_token"
		let authorizeURLString = "https://www.flickr.com/services/oauth/authorize"
		let accessTokenURLString = "https://www.flickr.com/services/oauth/access_token"
		
		let oauthswift = OAuth1Swift(
			consumerKey: APIKey,
			consumerSecret: secret,
			requestTokenUrl: requestTokenURLString,
			authorizeUrl: authorizeURLString,
			accessTokenUrl: accessTokenURLString
		)
		
		oauthswift.authorizeWithCallbackURL(
			NSURL(string: "com.NasakinMaxim.Flickr://oauthCallback")!,
			success: { credential, response, parameters in
				print("SUCCESS")
			}, failure: { error in
				print(error.localizedDescription)
			}
		)
		
		self.oauthswift = oauthswift
	}
	
	func comment(photoID: String, text: String, completion: (CommentCompletion) -> ()) {
		let params = [
			"photo_id": photoID,
			"comment_text": text
		]
		let url = FlickrURL.flickrURL(method: .AddComment, parameters: params)
		
		oauthswift?.client.post(
			url.URLString,
			success: { data, response in
				print("COMMENTED!")
				completion(.Success)
			}) { error in
				print(error)
				completion(.Failure(error))
		}
	}
}
