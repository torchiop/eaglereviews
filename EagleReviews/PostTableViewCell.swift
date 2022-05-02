//
//  PostTableViewCell.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var post: Post! {
        didSet {
            titleLabel.text = post.title
            textLabel.text = post.text
        }
    }
}

