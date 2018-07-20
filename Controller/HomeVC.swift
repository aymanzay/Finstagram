//
//  HomeVC.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/2/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        //extracting data from datasnapshots
        DBProvider.Instance.userPostsRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["Caption"] as! String
                let photoUrlString = dict["Photo Download URL"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
        } else {
            alertTheUser(title: "Could not log out.", message: "Could not log out at the moment, try again later.")
        }
    }

}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count //number of rows displayed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //improves display performance
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
