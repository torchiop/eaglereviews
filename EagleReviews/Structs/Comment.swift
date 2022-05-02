//
//  Comment.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import Foundation
import Firebase

class Comment {
    var text: String
    var reviewUserID: String
    var reviewUserEmail: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["text": text, "reviewUserID": reviewUserID, "reviewUserEmail": reviewUserEmail]
    }
    
    init(text: String, reviewUserID: String, reviewUserEmail: String, documentID: String) {
        self.text = text
        self.reviewUserID = reviewUserID
        self.reviewUserEmail = reviewUserEmail
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        let reviewUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(text: "", reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let reviewUserEmail = dictionary["reviewUserEmail"] as! String? ?? ""
        let documentID = dictionary["title"] as! String? ?? ""
        
        self.init(text: text, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, documentID: documentID)
    }
    
    func saveData(post: Post, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDoctument will create one.
        if self.documentID == "" { // Create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("posts").document(post.documentID).collection("comments").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID) to post: \(post.documentID)") // It worked!
                completion(true)
            }
        } else { // Else save to the exisiting documentID w/ .setData
            let ref = db.collection("posts").document(post.documentID).collection("comments").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: Updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID) in post: \(post.documentID)") // It worked!
                completion(true)
            }
        }
    }
    
    func deleteData(post: Post, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("posts").document(post.documentID).collection("comments").document(documentID).delete { error in
            if let error = error {
                print("Error: Deleting comment documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(self.documentID)")
                completion(true)
            }
        }
    }
}
