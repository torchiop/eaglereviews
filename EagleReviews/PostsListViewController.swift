//
//  PostsListViewController.swift
//  EagleReviews
//
//  Created by Peter Torchio on 5/2/22.
//

import UIKit

class PostsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: Posts!

    override func viewDidLoad() {
        super.viewDidLoad()
        posts = Posts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
        posts.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostDetail" {
            let destination = segue.destination as! ProfessorDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.professor = professors.professorArray[selectedIndexPath!.row]
        }
    }
    
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.titleLabel?.text = posts.postArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

