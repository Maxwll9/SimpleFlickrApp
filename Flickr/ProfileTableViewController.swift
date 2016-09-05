//
//  ProfileTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
	
	var viewModel: ProfileViewModel!
	
	@IBOutlet var buddyiconImageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var locationLabel: UILabel!
}

// MARK: View Lifecycle
extension ProfileTableViewController {
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationVC = segue.destinationViewController as? PhotoDetailTableViewController
		destinationVC?.profileBarButtonItem.enabled = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupRefreshControl()
		refresh()
	}
}

// MARK: Layout
extension ProfileTableViewController {
	private func refresh() {
		usernameLabel.text = ""
		locationLabel.text = ""
		
		viewModel.loadProfile(configureUI)
		
		viewModel.loadPhotos() { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
	
	private func configureUI() {
		let profile = viewModel.profile
		navigationItem.title = profile.userName
		
		usernameLabel.text = profile.realName ?? profile.userName
		
		if profile.location == nil { locationLabel.textColor = .grayColor() }
		locationLabel.text = profile.location ?? "no location"
		
		viewModel.loadBuddyIcon { [weak self] image in
			self?.buddyiconImageView.image = image
		}
		
		buddyiconImageView.layer.cornerRadius = buddyiconImageView.frame.size.width / 2
		buddyiconImageView.clipsToBounds = true
	}
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotosTableViewController.refresh), forControlEvents: .ValueChanged)
	}
	
	private func cellForRow(cell: PhotoTableViewCell, row: Int) {
		let photo = viewModel.photos[row]
		let photoURL = photo.smallImageURL
		
		cell.tag = row
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = nil
		cell.spinner.startAnimating()
		
		viewModel.sharedWebservice.loadImage(photoURL) { image in
			guard cell.tag == row else { return }
			
			cell.photoImageView.image = image
			cell.spinner.stopAnimating()
			cell.titleLabel.text = photo.title
			
			UIView.animateWithDuration(0.2) {
				cell.photoImageView.alpha = 1
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension ProfileTableViewController {
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.photos.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		cellForRow(cell, row: indexPath.row)
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.setCurrentPhoto(indexPath.row)
	}
}
