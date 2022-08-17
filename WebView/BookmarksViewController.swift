//
//  BookmarksViewController.swift
//  WebView
//
//  Created by Max on 12.08.2022.
//

import UIKit
import SafariServices
import WebKit

class BookmarksViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView?
        
    let indentifire = "MyCell"
    
    var bookmarkBlock: ((_ name: String, _ url: URL) -> Void)?
    
    var bookmarkArray = Bookmark.bookmarks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bookmarks"
        
        myTableView?.tableFooterView = UIView()
    }
    @IBAction func deleteCell(_ sender: UIButton) {
        guard let tv = myTableView else {
            return
        }
        tv.isEditing = !tv.isEditing
    }
}

extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
        let myCell = cell as? BookmarksCell
        
        let bookmarks = bookmarkArray[indexPath.row]
        
        myCell?.lableInCell?.text = bookmarks.name
        myCell?.lableInCellUrl?.text = bookmarks.url?.absoluteString

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = bookmarkArray[indexPath.row]
        guard let name = bookmark.name, let url = bookmark.url else {
            return
        }
        bookmarkBlock?(name, url)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookmarkArray.remove(at: indexPath.row)
            Bookmark.bookmarks = bookmarkArray
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

class BookmarksCell: UITableViewCell {
    @IBOutlet weak var lableInCell: UILabel?
    @IBOutlet weak var lableInCellUrl: UILabel?
}
