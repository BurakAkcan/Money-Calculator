//
//  ModelSingleton.swift
//  Money Calculator
//
//  Created by Burak AKCAN on 27.06.2022.
//

import Foundation
import RealmSwift



class Aktivities:Object,ObjectKeyIdentifiable{
   @Persisted(primaryKey: true) var id : ObjectId
   @Persisted var name:String = ""
   @Persisted var isActive:Bool = false
    //Realm da tablolar arasında ilşki kurmamız için List kullanırız
    @Persisted var odemeler : List<Odeme>
    
    
    convenience  init(name:String,isActive:Bool) {
        self.init()
        self.name = name
        self.isActive = isActive
        
    }
}


