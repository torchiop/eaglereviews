//
//  Post.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import Foundation
import Firebase

class Post {
    var title: String
    var text: String
    var postUserID: String
    var postUserEmail: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "postUserID": postUserID, "postUserEmail": postUserEmail]
    }
    
    init(title: String, text: String, postUserID: String, postUserEmail: String, documentID: String) {
        self.title = title
        self.text = text
        self.postUserID = postUserID
        self.postUserEmail = postUserEmail
        self.documentID = documentID
    }
    
    convenience init() {
        let postUserID = Auth.auth().currentUser?.uid ?? ""
        let postUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(title: "", text: "", postUserID: postUserID, postUserEmail: postUserEmail, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let postUserID = dictionary["postUserID"] as! String? ?? ""
        let postUserEmail = dictionary["postUserEmail"] as! String? ?? ""
        let documentID = dictionary["title"] as! String? ?? ""
        
        self.init(title: title, text: text, postUserID: postUserID, postUserEmail: postUserEmail, documentID: documentID)
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab user ID
        guard let postUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not save data because we don't have a valid postingUserID.")
            return completion(false)
        }
        self.postUserID = postUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDoctument will create one.
        if self.documentID == "" { // Create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("professors").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)") // It worked!
                completion(true)
            }
        } else { // Else save to the exisiting documentID w/ .setData
            let ref = db.collection("posts").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: Updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID)") // It worked!
                completion(true)
            }
        }
    }
    
    func deleteData(post: Post, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("posts").document(post.documentID).delete { error in
            if let error = error {
                print("Error: Deleting review documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(self.documentID)")
                completion(true)
            }
        }
    }
}

