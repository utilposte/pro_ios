//
//  ColissimoManagerDelegate.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 30/10/2018.Sprint 5
//

import Foundation

public protocol ColissimoManagerDelegate {
    func setUpNavigationItem(navigationItem : UINavigationItem)
    func homeViewDidCallStep1With()
    func homeViewDidCallStep2With()
    func homeViewDidCallStep3With()

    func homeViewDidCallStep6With()
    func didCallRecap()
    func step6ViewDidCallPrice()
    func didCallSenderForm()
    func didCallReceiverForm()
    func didCallFormalities()

    func senderFormDidCallAuthentification()
    func customFormalitiesDidCallMoreInfo(url: String)
    func redirectToCart()
    func getFooterView() -> UIView
    
    func homeViewDidCallDirectlyRecap(containsFormalities: Bool, step: Int)
}
