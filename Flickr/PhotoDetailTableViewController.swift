//
//  PhotoDetailTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 21/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotoDetailTableViewController: UITableViewController {
	var viewModel: PhotoDetailViewModel!
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var spinner: UIActivityIndicatorView!
	
	@IBOutlet var profileBarButtonItem: UIBarButtonItem!
	@IBOutlet var composeBarButtonItem: UIBarButtonItem!
}

// MARK: IBActions
extension PhotoDetailTableViewController {
	@IBAction func unwindToPhotoDetail(segue: UIStoryboardSegue) {
	}
}

// MARK: View Lifecycle
extension PhotoDetailTableViewController {
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
}

// MARK: Layout
extension PhotoDetailTableViewController {
	private func configureUI() {
		navigationItem.title = viewModel.photo.title
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		composeBarButtonItem.enabled = viewModel.stateViewModel.isAuthorized
		
		setupRefreshControl()
		refresh()
	}
	
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotoDetailTableViewController.refresh), forControlEvents: .ValueChanged)
	}
	
	func refresh() {
		spinner.startAnimating()
		
		viewModel.loadImage { [weak self] image in
			self?.imageView.image = image
			self?.spinner.stopAnimating()
		}
		
		viewModel.loadComments { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
}

// MARK: - UITableViewDataSource
extension PhotoDetailTableViewController {
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.comments.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
		viewModel.cellForRow(cell, indexPathRow: indexPath.row)
		return cell
	}
	
}
