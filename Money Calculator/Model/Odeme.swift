//
//  Odeme.swift
//  Money Calculator
//
//  Created by Burak AKCAN on 29.06.2022.
//

import Foundation
import RealmSwift

class Odeme:Object,ObjectKeyIdentifiable {
    @Persisted var payName:String = ""
    @Persisted var info :String = ""
    @Persisted var price:Int = 0
  //  var activity = LinkingObjects(fromType: Aktivities.self, property: "odemeler")
    @Persisted(originProperty: "odemeler") var activity : LinkingObjects<Aktivities>
    
    convenience init(payName:String,info:String,price:Int){
        self.init()
        self.payName = payName
        self.info = info
        self.price = price
        
    }
}
