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

struct Webservice {
	static func load<A>(resource: Resource<A>, completion: A? -> ()) {
		Alamofire.request(.GET, resource.url).responseData { response in
			let result = response.data.flatMap(resource.parse)
			completion(result)
		}
	}
	
	static func loadImage(imageView: UIImageView, url: NSURL, completion: (() -> ())?) {
		imageView.image = nil
		Nuke.taskWith(url) { result in
			if case let.Success(image, _) = result {
				imageView.image = image
				completion?()
			}
		}.resume()
	}
}
