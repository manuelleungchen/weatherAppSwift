//
//  weatherViewController.swift
//  weatherApp
//
//  Created by Manuel Leung Chen on 2019-04-18.
//  Copyright © 2019 Manuel Leung Chen. All rights reserved.
//

import UIKit
import CoreData

class weatherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, savingCityDegelateProtocol, weatherAPIDelegateProtocol{
    
    
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var citiesPickerView: UIPickerView!
    
    
    
    
    
    var allCities = [City]()
    
    var myWeather = weatherAPI()
    
    var pickerViewIndex = IndexPath(row: 0, section: 0)
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let myDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    @IBAction func removeButton(_ sender: Any)
    {
        context.delete(allCities[pickerViewIndex.row])
        myDelegate.saveContext()
        fetch()
        citiesPickerView.reloadAllComponents()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myWeather.delegate = self
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func weatherDidFinishWithResult(temp : Double, status : String)
    {
        print(status)
        // convert from kelvin to celsius
        let celsiusTemp = round (temp - 273.15)
        tempLabel.text = "\(celsiusTemp)  C"
        
        // change temp tet color according to temp value
        if celsiusTemp > 20
        {
            tempLabel.textColor = UIColor.red
        }
        if (celsiusTemp > 10 && celsiusTemp <= 20)
        {
            tempLabel.textColor = UIColor.orange
        }
        
        if celsiusTemp <= 10
        {
            tempLabel.textColor = UIColor.blue
        }
        
        
        // change image according to weather main status
        if status == "Clouds"
        {
            weatherImage.image = UIImage(named: "clouds.png")
        }
        else if status == "Rain"
        {
            weatherImage.image = UIImage(named: "rain.png")
        }
        else if status == "Clear"
        {
            weatherImage.image = UIImage(named: "clear.png")
        }
        else if status == "Mist"
        {
            weatherImage.image = UIImage(named: "mist.png")
        }
        else
        {
            weatherImage.image = UIImage(named: "general.png")
        }
        
    }
    
    func cityTableViewDidFinish(seletedCity: City)
    {
        allCities.append(seletedCity)  // add new city to array
        let newIndex = allCities.count - 1
        let indexToSave = IndexPath(row: newIndex, section: 0)
        
        citiesPickerView.reloadAllComponents()
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return allCities[row].cityName as! String
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        pickerViewIndex = IndexPath(row: row, section: 0)
        
        let selectedCity = allCities[row].cityName
        
        // This removes the spaces in some cities name
        let filtedSelectedCity = selectedCity?.replacingOccurrences(of: " ", with: "%20")
        
        myWeather.searchForWeather(searchText: filtedSelectedCity as! String)
    }

    
  
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return allCities.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let cityTVC = segue.destination as! searchCityTableViewController
        cityTVC.delegateSavingCity = self
    }
    
    
    func fetch ()
    {
        
        let fetchRequest : NSFetchRequest<City> = City.fetchRequest()
        
        // only to sorted the array
        //  let sorter1 = NSSortDescriptor(key: "stockSymbol", ascending: true)
        //  let sorter2 = NSSortDescriptor(key : "stockName", ascending : true)
        //  fetchRequest.sortDescriptors = [sorter1 ,sorter2]
        
        do
        {
            
            allCities = try context.fetch(fetchRequest)
            
        }
        catch
        {
            print(error)
        }
        
    }

   

}
