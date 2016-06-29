//
//  PhotoDetailTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 21/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoDetailTableViewController: UITableViewController {

	let viewModel = PhotoDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.title = viewModel.photo.title
		
		let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
		tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		viewModel.loadComments { self.tableView.reloadData() }
    }
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.comments.count
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
		let comment = viewModel.comments[indexPath.row]
		
		cell.configure(comment)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
		let header = cell as! TableSectionHeader
		
		Webservice.loadImage(header.imageView, url: viewModel.photo.remoteURLs.largeImageURL, completion: nil)
		
		return header
	}

}
