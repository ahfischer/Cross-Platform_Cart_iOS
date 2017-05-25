//
//  NetworkUtil.swift
//  A_Fischer_iOS_UsersAndData
//
//  Created by Anthony Fischer on 12/13/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import Foundation
import SystemConfiguration

open class NetworkUtil {
    
    // Function to check if internet is connected
    func hasInternet() -> Bool {
        
        // Reachability for internet connection
        var zeroAddress = sockaddr_in();
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress));
        zeroAddress.sin_family = sa_family_t(AF_INET);
        
        let reachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress);
            }
        };
        
        // Grab flags
        var flags = SCNetworkReachabilityFlags();
        if !SCNetworkReachabilityGetFlags(reachability!, &flags) {
            return false;
        }
        
        // Check if flags return true or false for reachable and connection
        let reachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0;
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0;
        
        return (reachable && !needsConnection);
    }
}
