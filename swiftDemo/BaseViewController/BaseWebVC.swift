//
//  BaseWebVC.swift
//
//
//  Created by *** on 27/1/21.
//  Copyright © 2021 ***. All rights reserved.
//

import UIKit
import WebKit

class BaseWebVC: NoneBarController {
    
    public var urlString = ""
    public var customTitle: String?
    public var leftTitle: Bool = false
    
    @objc var webViewCanGoBack = true
    public var showProgress:Bool = true
    public var webBounces:Bool = true
    /// Webpage starts loading
    @objc public var webStartAction:(()->())?
    /// Page loaded
    @objc public var webFinishAction:((Bool)->())?
    
    // MARK: - WebView
    public lazy var webView: WKWebView = {
        
        let webView = WKWebView(frame: CGRect(x: 0, y: getNaviHeight(), width: kScreenW, height: kScreenH-getNaviHeight()), configuration: config)
        webView.scrollView.bounces = webBounces
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.backgroundColor = UIColor(hex: "FFFFFF")
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        return webView
    }()
    private lazy var config: WKWebViewConfiguration = {
       
        let config = WKWebViewConfiguration()
        
        let jSString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: jSString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        config.userContentController = userContentController
        
        config.userContentController.add(webviewHandler, name: "tempProtocol")
        
        return config
    }()
    private lazy var webviewHandler: BaseWebHandler = {
        $0.delegate = self
        return $0
    }(BaseWebHandler())
    
    
    // MARK: - NavigationBar
    private lazy var naviBar: UIView = {
        
        let naviBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: getNaviHeight()))
        naviBar.backgroundColor = UIColor.white
        
        naviBar.addSubview(naviBarTitle)
        naviBar.addSubview(backAction)
        naviBar.addSubview(progressView)
        
        naviBarTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(naviBar.snp.bottom).offset(-22)
            make.centerX.equalTo(naviBar.snp.centerX)
        })
        
        return naviBar
    }()
    public lazy var naviBarTitle: UILabel = {
        let naviBarTitle = UILabel()
        naviBarTitle.textColor = UIColor.black
        naviBarTitle.font = UIFont.customFont(name: CustomFontName.PingFangSCRegular, size: 18)
        naviBarTitle.textAlignment = .center
        naviBarTitle.text = "WebView"
        return naviBarTitle
    }()
    //back
    private lazy var backAction: UIView = {
        let backAction = UIView(frame: CGRect(x: 0, y: 0, width: frameMath(70), height: getNaviHeight()))
        backAction.addSubview(self.backImage)
        backAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftAction(_:))))
        return backAction
    }()
    private lazy var backImage: UIImageView = {
        let backImage = UIImageView(frame: CGRect(x: frameMath(20), y: getStatusHeight() + (44-frameMath(18))/2, width: frameMath(10), height: frameMath(18)))
        backImage.image = UIImage(named: "asset_back_button")
        return backImage
    }()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: getNaviHeight()-2, width: self.view.frame.size.width, height: 2))
        progressView.tintColor = UIColor(hex: "#0096FF")
        progressView.trackTintColor = UIColor(hex: "#FFFFFF")
        return progressView
    }()
    
    var htmlString: String = "" {
        didSet {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc init(url:String?) {
        super.init(nibName: nil, bundle: nil)
        urlString = url?.replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        if title == nil { naviBarTitle.text = "WebView" }
        view.addSubview(naviBar)
        view.insertSubview(webView, belowSubview: progressView)
        
        guard let url = URL(string: urlString) else {
            return
        }
        let request = NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        
        webView.load(request as URLRequest)
        
        if leftTitle {
            naviBarTitle.textAlignment = .left
            naviBarTitle.snp.remakeConstraints({ make in
                make.centerY.equalTo(naviBar.snp.bottom).offset(-22)
                make.left.equalTo(backAction.snp.right).offset(frameMath(-15))
                make.right.equalTo(naviBar.snp.right).offset(frameMath(-20))
            })
        } else {
            naviBarTitle.textAlignment = .center
            naviBarTitle.snp.remakeConstraints({ make in
                make.centerY.equalTo(naviBar.snp.bottom).offset(-22)
                make.centerX.equalTo(naviBar.snp.centerX)
            })
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
        
        // MARK: - 删除对 js调原生 方法的监听
        self.webView.configuration.userContentController.removeAllUserScripts()
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:KVO监听事件--webview进度
extension BaseWebVC {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let webProgress = webView.estimatedProgress
        progressView.setProgress(Float(webProgress), animated: true)
        progressView.isHidden = webProgress >= 1  ? true : false
        
        if webProgress >= 1 { progressView.progress = Float(0) }
        
        var title = webView.title ?? ""
        if title.count > 20 { title = NSString(string: title).substring(to: title.count > 20 ? 20 : title.count) + "..." }
        
        naviBarTitle.text = title
        
        naviBarTitle.text = webView.title
        if customTitle != nil {
            naviBarTitle.text = customTitle
        }
        naviBarTitle.text = ""
    }
}

//MARK:导航条按钮事件
extension BaseWebVC {
    
    //MARK:导航条左边返回按钮
    @objc func leftAction(_ sender:UIButton){
        
//        if self.webViewCanGoBack && self.webView.canGoBack == true {
//            self.webView.goBack()
//        } else {
            self.navigationController?.popViewController(animated: true)
//        }
    }
}

//MARK:webview代理事件
extension BaseWebVC: WKUIDelegate, UIWebViewDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let cred = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, cred)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        if let _ = navigationAction.request.url?.absoluteString {
            
            decisionHandler(.allow, preferences)
            
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = self.webFinishAction {
            handler(true)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = self.webFinishAction {
            handler(false)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        // If user redirect out side, wehview will pop to detail screen.
//        print(webView.url?.absoluteString)
        
//        if let myUrl:String = webView.url?.absoluteString {
//            if myUrl.contains("pdf") {
//                guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
//                       return
//                    }
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
        
        if let handler = self.webStartAction{
            handler()
        }
        
//        if let url:String = webView.url?.absoluteString {
//            if url.contains("itunes.apple.com") {
//                UIApplication.shared.openURL(URL.init(string: url)!)
//            }
//        }
    }
}

//MARK:- webView的交互事件代理方法
extension BaseWebVC: BaseWebViewProtocol {
    
    //js  调原生 timeline
    func tempProtocol(_ url:String) {
        
    }
}

/*
webView?.evaluateJavaScript("setToken('\(token)')") { (reslut, error) in
    if error == nil {
        print("====================\nsetToken_reslut:\(reslut ?? "")")
    } else {
        print("====================\nsetToken_error:\(error.debugDescription)")
    }
}*/

