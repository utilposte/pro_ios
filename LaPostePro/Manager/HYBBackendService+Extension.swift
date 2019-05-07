//
//  HYBBackendService+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 23/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

extension HYBBackendService {
    func getDeliveryModeURL() -> String {
        return self.restPrefix() + "/users/\(userId ?? "")/carts/current/deliverymodes"
    }
    
    func urlRefreshToken() -> String {
        return self.restPrefix() + "/users/" + userId + "/refreshToken"
    }
    
    func urlUserInfo() -> String {
        return self.restPrefix() + "/users/" + userId + "/getProUserInfos"
    }
    
    func urlScoreClaimReason() -> String {
        return self.restPrefix() + "/users/" + userId + "/score/scoreMapping"
    }

    func urlScoreClaim() -> String {
        return self.restPrefix() + "/users/" + userId + "/score/reclamation"
    }
    
}
