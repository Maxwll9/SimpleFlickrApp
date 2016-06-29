//
//  Resource.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

struct Resource<A> {
	let url: NSURL
	let parse: NSData -> A?
}

extension Resource {
	init(url: NSURL, parseJSON: AnyObject -> A?) {
		self.url = url
		self.parse = { data in
			if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
				return parseJSON(json)
			}
			return nil
		}
	}
}
