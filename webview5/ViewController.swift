//
//  ViewController.swift
//  webview2
//
//  Created by Michael Tran on 10/11/2015.
//  Copyright © 2015 intcloud. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!

  override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self; // this line is to link with the UIWebViewDelegate protocol for bridging purpose.  - line 1
        webview.scrollView.bounces = false; // block your webview from bouncing so it works as an app. - line 2
        let localfilePath = NSBundle.mainBundle().URLForResource("index1.html", withExtension: "", subdirectory: "www"); // load file index.html in www - line 3
        let request = NSURLRequest(URL: localfilePath!); // get the request to the file - line 4
        webview.loadRequest(request); // load it on the webview - line 5
        
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// Callback when the webpage is finished loading
    func webViewDidFinishLoad(web: UIWebView){
// looking for the current URL
        let currentURL = web.request?.URL?.absoluteString;
        print("html content loaded! " + currentURL!);
        
    }
    
// this is the main function to trap JS call via document.location either by click or js function call
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType nType: UIWebViewNavigationType) -> Bool {
            
//the request.URL?.scheme is the first part of the document.location before the first ':'. It is originally http, or https, or file.  in Js can be anything predefined ie aaa bbb, in this case we use 'bridge:'
            print("scheme is : " + request.URL!.scheme);
            
            if (request.URL?.scheme == bridge_theme)
            {
                myrecord = process_scheme((request.URL?.absoluteString)!);
                switch myrecord.function {
                    case "ios_alert":alert("Bridging" , message: myrecord.param);
                    case "ios_popup": pop_new_page(myrecord.param);
                    case "ios_pop_message": pop_message(myrecord.param);
                    case "exchange" : do_exchange(myrecord.param);
                    default : print("dont know function name: \(myrecord.function)")
                }

                return false;
            }
            return true;

    }
    
    func do_exchange(txt: String) {
        _ = call_js("js_show_data", param: "back to JS: Hi there I got your package");
    }
    
   
// popup a screen on top of main screen
    func pop_new_page(txt: String) {
        
        //create webview
        let myWebView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height ))
        
        // format txt to NSURL
        let full_path = NSURL (string: txt);
        // detect the protocol
        let scheme = full_path!.scheme;
        //get filename put of it
        let filename = full_path!.lastPathComponent;
        // get path out of it
        let pathPrefix = txt.stringByDeletingLastPathComponent;
        print(pathPrefix + " " + filename!);
        let root_dir = "";
        //it is local file
        var myurl = NSBundle.mainBundle().URLForResource( filename, withExtension: "", subdirectory: root_dir + pathPrefix);
        //or a link?
        if (scheme == "http") || (scheme == "https") {
            myurl = full_path;
        }
        
        let requestObj = NSURLRequest(URL: myurl!);
        myWebView.loadRequest(requestObj);
        
        // add the webview into the uiviewcontroller
        let screen_name = "popup";
        // load uiview from nib
        let viewController = popup(nibName: screen_name, bundle: nil);
        viewController.view.addSubview(myWebView);
        viewController.view.sendSubviewToBack(myWebView);
        
// slide in or popup
        
        if navigationController != nil {
            self.navigationController?.pushViewController(viewController, animated: true)
            
        } else {
            presentViewController(viewController, animated: true, completion: nil);
        }
        
    }
    
    // run javascript on the page with result = call_js("js_fn", param:"rarameter");
    func call_js(function_name: String, param: String) -> String{
        var result = "";
        var full_path = function_name + "('" + param + "')";
        print("Run javascript: \(full_path)");
        
        result = webview.stringByEvaluatingJavaScriptFromString(full_path)!;
        return result;
    }


}
