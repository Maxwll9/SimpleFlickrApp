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
	
	@IBAction func segmentedControlDidChange(sender: AnyObject) {
		let selectedIndex = segmentedControl.selectedSegmentIndex
		
		viewModel.selectedIndex = selectedIndex
		
		if viewModel.photos[selectedIndex].count == 0 {
			refresh()
		} else {
			tableView.reloadData()
		}
	}
	
	// MARK: View Lifecycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		refresh()
		setupRefreshControl()
	}
	
	func refresh() {
		viewModel.loadPhotos() { [weak self] in
			self?.tableView.reloadData()
			self?.refreshControl?.endRefreshing()
		}
	}
	
	func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(PhotosTableViewController.refresh), forControlEvents: .ValueChanged)
	}
	
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		if segue.identifier == "ShowDetail" {
//			if let index = tableView.indexPathsForSelectedRows?.first?.row {
//				viewModel.setCurrentPhoto(index)
//			}
//		}
//	}

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos[viewModel.selectedIndex].count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		let selectedIndex = viewModel.selectedIndex
		let photo = viewModel.photos[selectedIndex][indexPath.row]
		let photoURL = photo.remoteURLs.smallImageURL
		
		cell.photoImageView.image = nil
		cell.titleLabel.text = nil
		cell.spinner.startAnimating()
		
		viewModel.sharedWebservice.loadImage(cell.photoImageView, url: photoURL) {
			cell.spinner.stopAnimating()
			cell.titleLabel.text = photo.title
			
			UIView.animateWithDuration(0.2) {
				cell.photoImageView.alpha = 1
			}
		}
		
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
//	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		viewModel.setCurrentPhoto(indexPath.row)
//	}
}
