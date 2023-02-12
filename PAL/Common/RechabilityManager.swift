//
//  RechabilityManager.swift
//
//  Created by i-Verve on 3/11/20.
//  Copyright © 2020 Iverve. All rights reserved.
//

import Foundation
import ReachabilitySwift

class RechabilityManager: NSObject{

    fileprivate var reachability: Reachability?
    //MARK:- SHAREDMANAGER
    static let shared : RechabilityManager =    {
        let instance = RechabilityManager()
        return instance
    }()


    func isInternetAvailableForAllNetworks() -> Bool{
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.isReachable || reachability!.isReachableViaWiFi || self.reachability!.isReachableViaWWAN
        }
        else{
            return reachability!.isReachable || reachability!.isReachableViaWiFi || self.reachability!.isReachableViaWWAN
        }
    }

    func doSetupReachability(){
        let reachability =  Reachability()
        self.reachability = reachability
        reachability?.whenReachable = { reachability in
        }
        reachability?.whenUnreachable = { reachability in
        }
        do {
            try reachability?.startNotifier()
        }
        catch {}
    }

    func internetUnreachable(handler: @escaping () -> Void){
        self.reachability?.whenUnreachable =
            { reachablility in
                handler()
        }
    }

    func internetReachable(handler: @escaping () -> Void){
        self.reachability?.whenReachable = { reachability in
            handler()
        }
    }
    deinit{
        reachability?.stopNotifier()
        reachability = nil
    }
}
