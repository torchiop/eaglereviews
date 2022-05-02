//
//  Reviews.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/30/22.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(professor: Professor, completed: @escaping () -> ()) {
        guard professor.documentID != "" else {
            return
        }
        db.collection("professors").document(professor.documentID).collection("reviews").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: Adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = []
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
