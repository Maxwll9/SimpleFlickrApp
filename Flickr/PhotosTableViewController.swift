//
//  PhotosTableViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 20/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {
	
	let viewModel = PhotosViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel.loadPhotos() { self.tableView.reloadData() }
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDetail" {
			if let selectedPath = tableView.indexPathsForSelectedRows?.first {
				let destinationVC = segue.destinationViewController as! PhotoDetailTableViewController
				let photo = viewModel.photos[selectedPath.row]
				
				destinationVC.viewModel.photo = photo
			}
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
		let photo = viewModel.photos[indexPath.row]
		let photoURL = photo.remoteURL

		Webservice.loadImage(cell.photoImageView, url: photoURL) {
			UIView.animateWithDuration(0.2) {
				cell.photoImageView.alpha = 1
			}
		}
		cell.titleLabel.text = photo.title
		
		return cell
	}

}
