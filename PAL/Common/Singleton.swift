//
//  Singleton.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import Foundation

class Singleton{
    
    static let shared = Singleton()
    
    func save(object: Any, key:String){
        let userDefault = UserDefaults.standard
        userDefault.set(object, forKey: key)
        userDefault.synchronize()
    }
    
        
    func get(key:String) -> Any? {
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: key)
    }
    
    func delete(key:String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
    
    func getUser() -> User? {
        if let user = self.get(key: UserDefaultsKeys.userData) as? [String:Any], let userObj = User(JSON: user){
            return userObj
        }else{
            return nil
        }
    }
}
