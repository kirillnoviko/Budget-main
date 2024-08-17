//
//  OperationStatistic.swift
//  BudgetProject
//
//  Created by User on 17.07.24.
//

import Foundation
import UIKit

struct Statistic{
    var name:String
    var percent:Float
    var amount:Float
    var image:UIImage
}

class OperationStatistic{
    
    var statistisc = [Statistic]()
    
    init() {
        setup()
    }
    
    func setup(){
        let p1 = Statistic(name: "StringSalary", percent: 50, amount: 1000, image: UIImage(named: "images" )!)
    
        let p2 = Statistic(name: "Investments", percent: 20, amount: 10300, image: UIImage(named: "images" )!)
    
        let p3 = Statistic(name: "Stock Dividends", percent: 30, amount: 100, image: UIImage(named: "images" )!)
    
        let p4 = Statistic(name: "Food", percent: 60, amount: 2420, image: UIImage(named: "images" )!)
    
       
        self.statistisc = [p1,p2,p3,p4]
        
    }
}
