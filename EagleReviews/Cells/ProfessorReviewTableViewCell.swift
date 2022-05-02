//
//  ProfessorReviewTableViewCell.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/30/22.
//

import UIKit

class ProfessorReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet var starImageCollection: [UIImageView]!
    
    var review: Review! {
        didSet {
            courseTitleLabel.text = review.course
            reviewTextLabel.text = review.text
        
        for starImage in starImageCollection {
            let imageName = (starImage.tag < review.rating ? "star.fill" : "star")
            starImage.image = UIImage(systemName: imageName)
            starImage.tintColor = (starImage.tag < review.rating ? UIColor(named: "Maroon") : .darkText)
        }
        }
    }
}
