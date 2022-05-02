//
//  ProfessorDetailViewController.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/27/22.
//

import UIKit

class ProfessorDetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var professor: Professor!
    var reviews: Reviews!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if professor == nil {
            professor = Professor()
        } else {
            disableTextEditing()
            cancelBarButton.hide()
            saveBarButton.hide()
            navigationController?.setToolbarHidden(true, animated: true)
        }
        reviews = Reviews()
        updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if professor.documentID != "" {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
        reviews.loadData(professor: professor) {
            self.tableView.reloadData()
            if self.reviews.reviewArray.count == 0 {
                self.ratingLabel.text = "-.-"
            } else {
                let sum = self.reviews.reviewArray.reduce(0) { $0 + $1.rating}
                var avgRating = Double(sum)/Double(self.reviews.reviewArray.count)
                avgRating = ((avgRating * 10).rounded())/10
                self.ratingLabel.text = "\(avgRating)"
            }
        }
    }
    
    func updateUserInterface() {
        nameTextField.text = professor.name
    }
    
    func updateFromInterface() {
        professor.name = nameTextField.text!
    }
    
    func disableTextEditing() {
        nameTextField.isEnabled = false
        nameTextField.backgroundColor = .clear
        nameTextField.borderStyle = .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromInterface()
        switch segue.identifier ?? "" {
        case "AddReview":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! ReviewTableViewController
            destination.professor = professor
        case "ShowReview":
            let destination = segue.destination as! ReviewTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.review = reviews.reviewArray[selectedIndexPath.row]
            destination.professor = professor
        default:
            print("Couldn't find a case for segue identifier \(segue.identifier). This should not have happened!")
        }
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        // Prevent a title of blank spaces from being saved, too
        let noSpaces = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func saveCancelAlert(title: String, message: String, segueIdentifier: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.professor.saveData { (success) in
                self.saveBarButton.title = "Done"
                self.cancelBarButton.hide()
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.disableTextEditing()
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateFromInterface()
        professor.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "Something went wrong when saving. Please try again.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    
    @IBAction func ratingButtonPressed(_ sender: UIButton) {
        if professor.documentID == "" {
            saveCancelAlert(title: "This professor has not been saved.", message: "You must save this professor before you can review it.", segueIdentifier: "AddReview")
        } else {
            performSegue(withIdentifier: "AddReview", sender: nil)
        }
    }
}

extension ProfessorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ProfessorReviewTableViewCell
        cell.review = reviews.reviewArray[indexPath.row]
        return cell
    }
}
