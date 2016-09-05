//
//  PhotosTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {
	
	var viewModel: PhotosViewModel!
	
	@IBOutlet var segmentedControl: UISegmentedControl!
	@IBOutlet var authorizeBarButtonItem: UIBarButtonItem!
}

// MARK: IBActions
extension PhotosTableViewController {
	@IBAction func segmentedControlDidChange(sender: AnyObject) {
		let selectedIndex = segmentedControl.selectedSegmentIndex
		
		viewModel.changeSegment(selectedIndex) { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@IBAction func authButtonDidPress(sender: AnyObject) {
		viewModel.toggleAuthorize(self) { [weak self] in
			self?.updateAuthButton()
		}
	}
}

// MARK: View Lifecycle
extension PhotosTableViewController {
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(true, animated: true)
		
		updateAuthButton()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refresh()
		setupRefreshControl()
	}
}


// MARK: Layout
extension PhotosTableViewController {
	func refresh() {
		viewModel.loadPhotos() { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotosTableViewController.refresh), forControlEvents: .ValueChanged)
	}
	
	private func updateAuthButton() {
		let imageName = (viewModel.stateViewModel.isAuthorized) ? "userFilled" : "userOutline"
		authorizeBarButtonItem.image = UIImage(named: imageName)
	}
	
	private func cellForRow(cell cell: PhotoTableViewCell, row: Int) {
		let photo = viewModel.photo(row)
		let photoURL = photo.smallImageURL
		
		cell.tag = row
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = photo.title
		cell.spinner.startAnimating()
		
		viewModel.sharedWebservice.loadImage(photoURL) { image in
			if cell.tag == row {
				cell.photoImageView.image = image
				cell.spinner.stopAnimating()
				
				UIView.animateWithDuration(1) {
					cell.photoImageView.alpha = 1
				}
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension PhotosTableViewController {
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.photos[viewModel.selectedIndex].count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		cellForRow(cell: cell, row: indexPath.row)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension PhotosTableViewController {
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.setCurrentPhoto(indexPath.row)
	}
}
