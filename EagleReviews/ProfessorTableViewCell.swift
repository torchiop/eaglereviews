//
//  ProfessorTableViewCell.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/27/22.
//

import UIKit

class ProfessorTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var professor: Professor! {
        didSet {
            nameLabel.text = professor.name
            let roundedAverage = ((professor.averageRating * 10).rounded()) / 10
            ratingLabel.text = "Avg. Rating: \(roundedAverage)"
        }
    }
}
