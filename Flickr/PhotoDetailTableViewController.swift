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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}

}
