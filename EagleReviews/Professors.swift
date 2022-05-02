//
//  Professors.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/27/22.
//

import Foundation
import Firebase

class Professors {
    var professorArray: [Professor] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("professors").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: Adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.professorArray = []
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let professor = Professor(dictionary: document.data())
                professor.documentID = document.documentID
                self.professorArray.append(professor)
            }
            completed()
        }
    }
}
