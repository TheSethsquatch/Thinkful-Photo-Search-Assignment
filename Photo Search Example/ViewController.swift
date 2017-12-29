//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Seth Levine on 12/21/17.
//  Copyright © 2017 Seth Levine. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

class ViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy("sunset")
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func searchFlickrBy(_ searchString:String) {
        let manager = AFHTTPSessionManager()
        
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "0081a6fff805f50292ef6ad9ee0dc2e3",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 10]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String: AnyObject] {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    self.scrollView.contentSize = CGSize(width: 320, height: 320 * CGFloat(photoArray.count))
                                    for (i,photoDictionary) in photoArray.enumerated() {
                                        if let imageURLString = photoDictionary["url_m"] as? String {
                                            let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:320, height:320))     //#1
                                            if let url = URL(string: imageURLString) {
                                                imageView.setImageWith(url)                                             //#2
                                                self.scrollView.addSubview(imageView)
                                            }
                                        }
                                    }
                                }
                            }
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrBy(searchText)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    

}

