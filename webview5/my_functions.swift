//
//  my_functions.swift
//  swift_bridge
//
//  Created by Michael Tran on 8/10/2015.
//  Copyright © 2015 intcloud. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

let bridge_theme = "bridge"; 
var myrecord = (function:"", param:"");

func process_scheme(url: String) -> (String, String) {
    var functionName = "";
    var param = "";
    let urlString = url;
    let theme_length = bridge_theme.characters.count + 1; // take away the :
    //delete first 7 chars
    let str = urlString.substringFromIndex(urlString.startIndex.advancedBy(theme_length));
    //look for the ? char
    let needle: Character = "?";
    //if it is not nul  -> found
    if let idx = str.characters.indexOf(needle) {
        //the pos of it from 1
        let pos = str.startIndex.distanceTo(idx);
        //how many char for the param
        let count_back = str.characters.count - pos;
        //take only whatever before the ?
        functionName = str.substringToIndex(str.endIndex.advancedBy(-1 * count_back));
        //take the whole param string
        param=str.substringFromIndex(str.endIndex.advancedBy(-1 * count_back));
        //delete the '?param=' part, it is 7 character length
        param=param.substringFromIndex(param.startIndex.advancedBy(7));
        //remove the uuencode for space
        param = param.stringByReplacingOccurrencesOfString("%20",
            withString: " ",
            options: NSStringCompareOptions.LiteralSearch,
            range: param.startIndex..<param.endIndex)
    }
    else {
        functionName = urlString.substringFromIndex(urlString.startIndex.advancedBy(7));
    }
    print("function = " + functionName + "\n" + "param= '" + param + "'");
    return (functionName, param);
}

// pop message or notify depending to active mode.
func pop_message(my_message: String) {
    var window: UIWindow?
    // Show an alert if application is active
    if UIApplication.sharedApplication().applicationState == .Active {
        alert("", message: my_message);
    } else {
        // Otherwise present a local notification
        let notification = UILocalNotification()
        notification.alertBody = my_message;
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow (notification)
    }
    
}


// usage : alert("network", message: "alive");
func alert (title: String, message: String) {
    let myalert = UIAlertView();
    myalert.title = title;
    myalert.message = message;
    myalert.addButtonWithTitle("OK");
    myalert.show();
}

// string class
extension String {

var lastPathComponent: String {

get {
    return (self as NSString).lastPathComponent
}
}
var pathExtension: String {

get {
    
    return (self as NSString).pathExtension
}
}
var stringByDeletingLastPathComponent: String {

get {
    
    return (self as NSString).stringByDeletingLastPathComponent
}
}
var stringByDeletingPathExtension: String {

get {
    
    return (self as NSString).stringByDeletingPathExtension
}
}
var pathComponents: [String] {

get {
    return (self as NSString).pathComponents
}
}

func stringByAppendingPathComponent(path: String) -> String {
    
    let nsSt = self as NSString
    
    return nsSt.stringByAppendingPathComponent(path)
}

func stringByAppendingPathExtension(ext: String) -> String? {
    
    let nsSt = self as NSString
    
    return nsSt.stringByAppendingPathExtension(ext)
}

} // string extention


