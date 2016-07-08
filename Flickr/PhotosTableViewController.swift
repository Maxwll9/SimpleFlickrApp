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
	
	@IBAction func segmentedControlDidChange(sender: AnyObject) {
		let selectedIndex = segmentedControl.selectedSegmentIndex
		
		viewModel.selectedIndex = selectedIndex
		
		if viewModel.photos[selectedIndex].count == 0 {
			refresh()
		} else {
			tableView.reloadData()
		}
	}
	
	@IBAction func authButtonDidPress(sender: AnyObject) {
			viewModel.authorize(self) { [weak self] in
				self?.updateAuthButton()
			}
	}
	
	// MARK: View Lifecycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(true, animated: true)
		viewModel.bigViewModel.isProfile = false
		
		updateAuthButton()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		refresh()
		setupRefreshControl()
	}
	
	// MARK: Layout
	
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
		let imageName = (viewModel.bigViewModel.isAuthorized) ? "userFilled" : "userOutline"
		authorizeBarButtonItem.image = UIImage(named: imageName)
	}

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos[viewModel.selectedIndex].count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		let selectedIndex = viewModel.selectedIndex
		let photo = viewModel.photos[selectedIndex][indexPath.row]
		let photoURL = photo.remoteURLs.smallImageURL
		
		cell.tag = indexPath.row
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = photo.title
		cell.spinner.startAnimating()
		
		viewModel.sharedWebservice.loadImage(photoURL) { image in
			if cell.tag == indexPath.row {
				cell.photoImageView.image = image
				cell.spinner.stopAnimating()
				
				UIView.animateWithDuration(1) {
					cell.photoImageView.alpha = 1
				}
			}
		}
		
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.setCurrentPhoto(indexPath.row)
	}
}
