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

	// MARK: View Lifecycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setToolbarHidden(true, animated: true)
		viewModel.bigViewModel.isProfile = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupRefreshControl()
		refresh()
	}
	
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
		if let location = profile.location {
			locationLabel.text = location
		} else {
			locationLabel.text = "no location"
			locationLabel.textColor = .grayColor()
		}
		
		viewModel.loadBuddyIcon { self.buddyiconImageView.image = $0 }
		buddyiconImageView.layer.cornerRadius = buddyiconImageView.frame.size.width / 2
		buddyiconImageView.clipsToBounds = true
	}
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotosTableViewController.refresh), forControlEvents: .ValueChanged)
	}

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		let photo = viewModel.photos[indexPath.row]
		let photoURL = photo.remoteURLs.smallImageURL
		
		cell.tag = indexPath.row
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = nil
		cell.spinner.startAnimating()
		
		viewModel.sharedWebservice.loadImage(photoURL) { image in
			if cell.tag == indexPath.row {
				cell.photoImageView.image = image
				cell.spinner.stopAnimating()
				cell.titleLabel.text = photo.title
				
				UIView.animateWithDuration(0.2) {
					cell.photoImageView.alpha = 1
				}
			}
		}
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.setCurrentPhoto(indexPath.row)
	}
}
