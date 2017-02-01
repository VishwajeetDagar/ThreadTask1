//
//  NetworkUtil.swift
//  ThreadApp1
//
//  Created by Vishwajeet Dagar on 1/31/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit

class NetworkUtil{
    
    func query(url:URL){
        
        let request=URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("Error trying to connect to internet.")
            }
            print(data)
        }
        task.resume()
    }
}
