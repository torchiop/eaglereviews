//
//  Review.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/30/22.
//

import Foundation
import Firebase

class Review {
    var course: String
    var text: String
    var rating: Int
    var reviewUserID: String
    var reviewUserEmail: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["course": course, "text": text, "rating": rating, "reviewUserID": reviewUserID, "reviewUserEmail": reviewUserEmail]
    }
    
    init(course: String, text: String, rating: Int, reviewUserID: String, reviewUserEmail: String, documentID: String) {
        self.course = course
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.reviewUserEmail = reviewUserEmail
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        let reviewUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(course: "", text: "", rating: 0, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let course = dictionary["course"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let reviewUserEmail = dictionary["reviewUserEmail"] as! String? ?? ""
        let documentID = dictionary["title"] as! String? ?? ""
        
        self.init(course: course, text: text, rating: rating, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, documentID: documentID)
    }
    
    func saveData(professor: Professor, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDoctument will create one.
        if self.documentID == "" { // Create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("professors").document(professor.documentID).collection("reviews").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID) to professor: \(professor.documentID)") // It worked!
                professor.updateAverageRating {
                    completion(true)
                }
            }
        } else { // Else save to the exisiting documentID w/ .setData
            let ref = db.collection("professors").document(professor.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: Updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID) in professor: \(professor.documentID)") // It worked!
                professor.updateAverageRating {
                    completion(true)
                }
            }
        }
    }
    
    func deleteData(professor: Professor, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("professors").document(professor.documentID).collection("reviews").document(documentID).delete { error in
            if let error = error {
                print("Error: Deleting review documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(self.documentID)")
                professor.updateAverageRating {
                    completion(true)
                }
            }
        }
    }
}
