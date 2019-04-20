//
//  citiesAPI.swift
//  weatherApp
//
//  Created by Manuel Leung on 2019-04-19.
//  Copyright © 2019 Manuel Leung Chen. All rights reserved.
//


import UIKit

protocol cityAPIDelegateProtocol
{
    func cityAPIDidFinishWithResult(array : NSArray)
}

class citiesAPI: NSObject {
    
    var delegate : cityAPIDelegateProtocol? = nil
    
    func getData(url : URL, completionHandler : @escaping (Data) -> ())
    {
        
        // Step 3
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: url)
        { (data, respons, error) in
            if let myData = data
            {
                let stringFromJson = String(decoding: myData, as: UTF8.self)
                
                let newString = stringFromJson.adjustJsonDataFromCitiesAPI()
                
                let validaJsonData = newString.data(using: .utf8)
                
                DispatchQueue.main.async
                    {
                        completionHandler(validaJsonData!)
                }
            }
        }
        
        task.resume()
    }
    
    func searchForText(searchText : String)
    {
        // Step 2
        
        let urlString = "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=\(searchText)"
        
        // Create url object
        
        let url : URL = URL(string: urlString)!  // force unwrape
        
        getData (url: url, completionHandler:
            {
                (jsonData) in do
                {
                    // Step 6
                    // Extract data
                    
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options:[]) as! NSArray
                    
                    // print (jsonObject)
                    
                    //   let resultArray = jsonObject.value(forKeyPath: "ResultSet.Result") as! NSArray
                    
                    let mainQ = DispatchQueue.main.async
                    {
                        print("data is ready")
                        
                        self.delegate?.cityAPIDidFinishWithResult(array: jsonObject)
                    }
                }
                    
                catch
                {
                    print("ok")
                }
                
        })
        
    }
    
}

