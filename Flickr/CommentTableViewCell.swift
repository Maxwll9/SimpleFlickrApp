//
//  CommentTableViewCell.swift
//  Flickr
//
//  Created by Maxim Nasakin on 29/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
	
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var commentLabel: UILabel!
	@IBOutlet var buddyIconImageView: UIImageView!

	func configure(comment: Comment) {
		nameLabel.text = comment.authorName
		commentLabel.text = comment.content
	}
}
