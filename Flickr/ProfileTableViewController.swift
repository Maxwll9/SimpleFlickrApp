//
//  ProfileTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 05/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

	@IBOutlet var buddyiconImageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var locationLabel: UILabel!
	
	var profileViewModel: ProfileViewModel?

	// MARK: View Lifecycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(true, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupRefreshControl()
		refresh()
	}
	
	func refresh() {
		viewModel!.loadProfile(configureUI)
		
		viewModel!.loadPhotos() { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
	
	func configureUI() {
		let profile = viewModel!.profile
		self.navigationItem.title = profile.userName
		
		self.usernameLabel.text = profile.realName ?? profile.userName
		self.locationLabel.text = profile.location ?? "no location"
		self.viewModel!.loadBuddyIcon(self.buddyiconImageView, completion: nil)
	}
	
	func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotosTableViewController.refresh), forControlEvents: .ValueChanged)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDetail" {
			if let selectedPath = tableView.indexPathsForSelectedRows?.first {
				let destinationVC = segue.destinationViewController as! PhotoDetailTableViewController
				let photo = viewModel!.photos[selectedPath.row]
				
				destinationVC.viewModel!.photo = photo
				destinationVC.profileBarButtonItem.enabled = false
			}
		}
	}

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.photos.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		let photo = viewModel!.photos[indexPath.row]
		let photoURL = photo.remoteURLs.smallImageURL
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = nil
		cell.spinner.startAnimating()
		
		viewModel!.sharedWebservice.loadImage(cell.photoImageView, url: photoURL) {
			cell.spinner.stopAnimating()
			cell.titleLabel.text = photo.title
			
			UIView.animateWithDuration(0.2) {
				cell.photoImageView.alpha = 1
			}
		}
		
		return cell
	}
}
