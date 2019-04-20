//
//  File.swift
//  weatherApp
//
//  Created by Manuel Leung on 2019-04-19.
//  Copyright © 2019 Manuel Leung Chen. All rights reserved.
//

import Foundation

extension String
{
    func adjustJsonDataFromCitiesAPI () -> String
    {
        // Step 4
        
        let firstIndex = self.index(self.startIndex, offsetBy: 2)
        let lastIndex = self.index(self.endIndex, offsetBy: -2)
        
        var newString = self.substring(to: lastIndex)
        
        newString = newString.substring(from: firstIndex)
        
        return newString
    }
    
}
