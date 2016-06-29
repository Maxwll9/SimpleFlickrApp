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
	@IBOutlet var commentLabel: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
