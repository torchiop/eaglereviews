//
//  Posts.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import Foundation
import Firebase

class Posts {
    var postArray: [Post] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("posts").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: Adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.postArray = []
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let post = Post(dictionary: document.data())
                post.documentID = document.documentID
                self.postArray.append(post)
            }
            completed()
        }
    }
}
