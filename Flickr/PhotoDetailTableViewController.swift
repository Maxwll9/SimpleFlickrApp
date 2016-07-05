//
//  PhotoDetailTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 21/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoDetailTableViewController: UITableViewController {
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var spinner: UIActivityIndicatorView!

	@IBOutlet var profileBarButtonItem: UIBarButtonItem!

	var viewModel: PhotoDetailViewModel!
	
	// MARK: View Lifecycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setToolbarHidden(false, animated: true)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		configureUI()
    }
	
	// MARK: Layout
	
	private func configureUI() {
		viewModel.loadImage(imageView) { [weak self] in
			self?.spinner.stopAnimating()
		}
		
		navigationItem.title = viewModel.photo.title
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotoDetailTableViewController.refresh), forControlEvents: .ValueChanged)
		refresh()
	}
	
	func refresh() {
		viewModel.loadComments { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.comments.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
		let comment = viewModel.comments[indexPath.row]
		
		cell.configure(comment)
		
		return cell
	}

}
