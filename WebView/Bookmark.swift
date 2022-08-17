//
//  Bookmark.swift
//  WebView
//
//  Created by Max on 12.08.2022.
//

import Foundation

class Bookmark: Codable {
    
    var name: String?
    var url: URL?
    
    func save() {
        var bookmarks = Bookmark.bookmarks
        bookmarks.append(self)
        Bookmark.bookmarks = bookmarks
    }
    
    static let bookmarkKey = "bookmarkKey"
    
    static var bookmarks: [Bookmark] {
        get {
            guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else {
                return []
            }
            
            let x = try? JSONDecoder().decode([Bookmark].self, from: data)
            return x ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.setValue(data, forKey: bookmarkKey)
            UserDefaults.standard.synchronize()
        }
    }
}
