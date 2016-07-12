//
//  PhotoTableViewCell.swift
//  Flickr
//
//  Created by Maxim Nasakin on 21/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
	
	@IBOutlet var photoImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var spinner: UIActivityIndicatorView!

	override func awakeFromNib() {
		super.awakeFromNib()
		configure()
	}
	
	private func configure() {
		photoImageView.alpha = 0

		let darkView = UIView(frame: photoImageView.bounds)
		darkView.backgroundColor = .blackColor()
		darkView.alpha = 0.2
		photoImageView.addSubview(darkView)
	}
}
