//
//  BookmarkViewController.swift
//  Surf
//
//  Created by Zhaowei Wu on 2017-11-19.
//  Copyright © 2017 Zhaowei Wu. All rights reserved.
//

import UIKit
import CoreData

protocol BookmarkDelegate {
    func userDidSelectBookmark(withUrl url: URL)
}

class BookmarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bookmarkDelegate: BookmarkDelegate? = nil

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var bookmarks: [Bookmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        bookmarkTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        do {
            bookmarks = try context.fetch(Bookmark.fetchRequest())
        } catch {
            print("Error: Failed to fetch data")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let bookmark = bookmarks[indexPath.row]
        if let title = bookmark.title {
            cell.textLabel?.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookmark = bookmarks[indexPath.row]
            context.delete(bookmark)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        getData()
        bookmarkTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        guard let delegate = bookmarkDelegate, let url = bookmarks[indexPath.row].url else { return }
        delegate.userDidSelectBookmark(withUrl: url)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
