//
//  weatherAPI.swift
//  weatherApp
//
//  Created by Manuel Leung Chen on 2019-04-18.
//  Copyright © 2019 Manuel Leung Chen. All rights reserved.
//

import UIKit

protocol weatherAPIDelegateProtocol
{
    func weatherDidFinishWithResult(temp : Double, status : String)
}

class weatherAPI : NSObject{
    
    
    var delegate : weatherAPIDelegateProtocol? = nil
    
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
                
                //let newString = stringFromJson.adjustJsonData()
                let newString = stringFromJson
                
                
                let validaJsonData = newString.data(using: .utf8)
                
                DispatchQueue.main.async
                    {
                        completionHandler(validaJsonData!)
                }
            }
        }
        
        task.resume()
    }
    
    func searchForWeather(searchText : String)
    {
        // Step 2
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchText)&appid=3c12dba7f4d99ba53bc5843b1a8f5f7c"
        
        // Create url object
        
        let url : URL = URL(string: urlString)!  // force unwrape
        
        getData (url: url, completionHandler:
            {
                (jsonData) in do
                {
                    // Step 6
                    // Extract data
                    
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options:[]) as! NSDictionary
                    
                    let myTemperature = jsonObject.value(forKeyPath: "main.temp") as! Double
                    
                    let myWeather = jsonObject.value(forKeyPath: "weather") as! NSArray
                    
                    let myStatus = (myWeather[0] as AnyObject).value(forKeyPath: "main") as! String
                    
                    let mainQ = DispatchQueue.main.async
                    {
                        print("data is ready")
                        
                        self.delegate?.weatherDidFinishWithResult(temp: myTemperature, status: myStatus)
                    }
                }
                    
                catch
                {
                    print("ok")
                }
                
        })
        
    }
    
}

