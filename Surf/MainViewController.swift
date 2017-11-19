//
//  MainViewController.swift
//  Surf
//
//  Created by Zhaowei Wu on 2017-11-18.
//  Copyright © 2017 Zhaowei Wu. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate, BookmarkDelegate {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlTextField.delegate = self
        webview.navigationDelegate = self
        setButtonImage()
        let urlString = "https://www.google.com" // main page of browser
        let url: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: url)
        webview.load(request)
        urlTextField.text = urlString
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let url = webview.url else { return }
        let request = URLRequest(url: url)
        webview.load(request)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let bookmark = Bookmark(context: context)
        bookmark.url = webview.url
        bookmark.title = webview.title
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let urlString = webview.url?.absoluteString
        let activityVC = UIActivityViewController(activityItems: [urlString!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func setButtonImage() {
        let backImage = UIImage(named: "back.png")
        let forwardImage = UIImage(named: "forward.png")
        let refreshImage = UIImage(named: "refresh.png")
        let likeImage = UIImage(named: "like.png")
        let settingImage = UIImage(named: "setting.png")
        let bookmarkImage = UIImage(named: "bookmark.png")
        let historyImage = UIImage(named: "history.png")
        let shareImage = UIImage(named: "share.png")
        backButton.setImage(backImage, for: .normal)
        forwardButton.setImage(forwardImage, for: .normal)
        refreshButton.setImage(refreshImage, for: .normal)
        likeButton.setImage(likeImage, for: .normal)
        settingButton.setImage(settingImage, for: .normal)
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        historyButton.setImage(historyImage, for: .normal)
        shareButton.setImage(shareImage, for: .normal)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString = urlTextField.text!
        let url: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: url)
        webview.load(request)
        urlTextField.resignFirstResponder() // dismiss keyboard
        return true
    }
    
    // MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        urlTextField.text = webView.url?.absoluteString
    }
    
    // MARK: BookmarkDelegate
    
    func userDidSelectBookmark(withUrl url: URL) {
        let request = URLRequest(url: url)
        webview.load(request)
    }
    
    // MARK: Acknowledge delegation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookmarks" {
            let bookmarkVC = segue.destination as! BookmarkViewController
            bookmarkVC.bookmarkDelegate = self
        }
    }

}

