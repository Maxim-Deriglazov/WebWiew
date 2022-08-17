//
//  ViewController.swift
//  WebView
//
//  Created by Max on 07.07.2022.
//

import UIKit
import SafariServices
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {    
    
    @IBOutlet weak var stopTextField: UITextField?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var activIndView: UIActivityIndicatorView?
    @IBOutlet weak var falsView: UIView?
    @IBOutlet weak var webView: WKWebView?
    
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var forwardButton: UIButton?
    
    var stop = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
    }
    
    func getUrl() -> URL? {
        guard var text = textField?.text else {
            return nil
        }
        
        let https = "https://"
        if !text.hasPrefix(https) {
            text = https + text
        }
        
        guard let url = URL(string:text) else {
            return nil
        }
        return url
    }
    
    @IBAction func addStop(_ sender: UIButton) {
        if let str = stopTextField?.text {
            stop.append(str)
        }
    }

    @IBAction func go(_ sender: UIButton) {
        guard let url = getUrl() else { return }
        
        let request = URLRequest(url: url)
        webView?.load(request)
    }

    @IBAction func back(_ sender: UIButton) {
        webView?.goBack()
    }
    
    @IBAction func forward(_ sender: UIButton) {
        webView?.goForward()
    }
    
    @IBAction func saveUrl(_ sender: UIButton) {
        let newbookmar = Bookmark()
        newbookmar.name = webView?.title
        newbookmar.url = webView?.url
        newbookmar.save()
                
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "BookmarksViewController") as? BookmarksViewController {
         
            vc.bookmarkBlock = { [weak self] (name, url) in
                guard let vc = self else { return }
                
                vc.navigationController?.popToViewController(vc, animated: true)
                
                let request = URLRequest(url: url)
                vc.webView?.load(request)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func reloadButton(_ sender: UIButton) {
        webView?.reload()
    }
 
    @IBAction func showSafariButton(_ sender: UIButton) {
        guard let url = getUrl() else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton?.isEnabled = webView.canGoBack
        forwardButton?.isEnabled = webView.canGoForward
        activIndView?.isHidden = true
        falsView?.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activIndView?.isHidden = false
        falsView?.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var policy: WKNavigationActionPolicy = .allow
        let path = navigationAction.request.url?.absoluteString
        for word in stop {
            if path?.contains(word) == true {
                policy = .cancel
                
                let vc = UIAlertController(title: "Attention!", message: "Forbidden word is used", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
                vc.addAction(cancelAction)
                present(vc, animated: true, completion: nil)
                
                break
            }
        }
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        activIndView?.isHidden = true
        
        let vc = UIAlertController(title: "ERROR!", message: "non-existent URL", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        vc.addAction(cancelAction)
        present(vc, animated: true, completion: nil)
    }
}


