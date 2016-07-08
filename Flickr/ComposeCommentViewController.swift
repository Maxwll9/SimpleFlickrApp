//
//  ComposeCommentViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

class ComposeCommentViewController: UIViewController {
	
	var viewModel: ComposeCommentViewModel!

	@IBOutlet var commentTextView: UITextView!
	
	@IBAction func sendComment(sender: AnyObject) {
		viewModel.addComment(commentTextView.text) { result in
			var alertTitle: String
			
			switch result {
			case .Success:
				alertTitle = "Done!"
			case .Failure(_):
				alertTitle = "Error"
			}
			
			let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default) { _ in
				self.performSegueWithIdentifier("unwindToPhotoDetail", sender: self)
			}
			
			alert.addAction(action)
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		commentTextView.becomeFirstResponder()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupKeyboardNotifications()
	}
	
	
	func setupKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeCommentViewController.keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeCommentViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWasShown(aNotification:NSNotification) {
		let info = aNotification.userInfo
		let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
		let kbSize = infoNSValue.CGRectValue().size
		let contentBottomInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0).bottom
		commentTextView.contentInset.bottom = contentBottomInsets
		commentTextView.scrollIndicatorInsets.bottom = contentBottomInsets
	}
	
	func keyboardWillBeHidden(aNotification:NSNotification) {
		let contentBottomInsets = UIEdgeInsetsZero.bottom
		commentTextView.contentInset.bottom = contentBottomInsets
		commentTextView.scrollIndicatorInsets.bottom = contentBottomInsets
	}
}
