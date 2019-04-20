//
//  searchCityTableViewController.swift
//  weatherApp
//
//  Created by Manuel Leung on 2019-04-19.
//  Copyright © 2019 Manuel Leung Chen. All rights reserved.
//
import UIKit
import CoreData

protocol savingCityDegelateProtocol
{
    func cityTableViewDidFinish (seletedCity : City)
}

class searchCityTableViewController: UITableViewController, UISearchBarDelegate, cityAPIDelegateProtocol {
    
    
    var myCitiesAPI = citiesAPI()
    var allCities = [String]()
    
    var delegateSavingCity : savingCityDegelateProtocol? = nil
    
    // need for coredata use
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let myDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    func cityAPIDidFinishWithResult(array : NSArray)
    {
        allCities = array as! [String]
        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCitiesAPI.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allCities.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = allCities[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let thisString = allCities[indexPath.row]
        
        if checkForDuplicates(stocksymbol: thisString)
        {
            self.navigationController?.popViewController(animated: true)     // return to weatherViewController
        }
            
        else
        {
            let cityToSave = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
            
            cityToSave.cityName = thisString
            
            myDelegate.saveContext()
            self.delegateSavingCity?.cityTableViewDidFinish(seletedCity: cityToSave)
            self.navigationController?.popViewController(animated: true)    // return to weatherViewController
        }
    }
    
    func checkForDuplicates (stocksymbol : String) -> Bool
    {
        let fetchRequest : NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "cityName = %@", stocksymbol)   // case sensitibve for the atribute name
        
        fetchRequest.predicate = predicate
        var isDuplicated = false
        do
        {
            let theResults = try myDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            if theResults.count > 0
            {
                isDuplicated = true
                print("Duplicated")
            }
            else
            {
                isDuplicated = false
                print("No duplicated")
            }
        }
        catch
        {
            print("Error checking duplicates")
        }
        return isDuplicated
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print(searchText)
        let filtedSearchCity = searchText.replacingOccurrences(of: " ", with: "%20")
        myCitiesAPI.searchForText(searchText: filtedSearchCity)
    }
    
    
    
    
    
    
}
