//
//  CommentTableViewController.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import UIKit
import Firebase

class CommentTableViewController: UITableViewController {

    var comment: Comment!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard post != nil else {
            print("Error: No post passed to CommentTableViewController.swift")
            return
        }
        if comment == nil {
            comment = Comment()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = professor.name
        reviewTitleField.text = review.course
        reviewTextView.text = review.text
        rating = review.rating // will update rating stars on load
        if review.documentID == "" {
            addBordersToEditableObjects()
        } else {
            if review.reviewUserID == Auth.auth().currentUser?.uid { // Review posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            } else { // Review posted by different user
                saveBarButton.hide()
                cancelBarButton.hide()
                for starButton in starButtonCollection {
                    starButton.backgroundColor = .white
                    starButton.isEnabled = false
                }
                reviewTitleField.isEnabled = false
                reviewTitleField.borderStyle = .none
                reviewTextView.isEditable = false
                reviewTitleField.backgroundColor = .white
                reviewTextView.backgroundColor = .white
            }
        }
    }
    
    func updateFromUserInterface() {
        review.course = reviewTitleField.text!
        review.text = reviewTextView.text!
    }
    
    func addBordersToEditableObjects() {
        reviewTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        buttonsBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

}
