//
//  NetworkHelpers.swift
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
