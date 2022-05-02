//
//  ProfessorListViewController.swift
//  EagleReviews
//
//  Created by Peter Torchio on 4/27/22.
//

import UIKit

class ProfessorListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    var professors: Professors!

    override func viewDidLoad() {
        super.viewDidLoad()
        professors = Professors()
        tableView.delegate = self
        tableView.dataSource = self
        configureSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
        professors.loadData {
            self.sortBasedOnSegementPressed()
            self.tableView.reloadData()
        }
    }
    
    func configureSegmentedControl() {
        // TODO: Set font colors for segmented control
        let orangeFontColor = [NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor") ?? UIColor.orange]
        let whiteFontColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
        sortSegmentedControl.setTitleTextAttributes(orangeFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(whiteFontColor, for: .normal)
        // Add white border to segmented control
        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.layer.borderWidth = 1.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ProfessorDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.professor = professors.professorArray[selectedIndexPath!.row]
        }
    }
    
    func sortBasedOnSegementPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: // A-Z
            professors.professorArray.sorted(by: {$0.name < $1.name})
        case 1: // averageRating
            professors.professorArray.sorted(by: {$0.averageRating < $1.averageRating})
        default:
            print("Check the segment control for an error.")
        }
        tableView.reloadData()
    }

    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegementPressed()
    }
    
}

extension ProfessorListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professors.professorArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfessorTableViewCell
        cell.nameLabel?.text = professors.professorArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
