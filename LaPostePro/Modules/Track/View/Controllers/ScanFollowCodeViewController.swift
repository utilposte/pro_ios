//
//  ScanFollowCodeViewController.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import AudioToolbox
import AVFoundation
import Foundation
import LPSharedSUIVI
import UIKit

class ScanFollowCodeViewController: UIViewController {
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var scanBar: UIView!
    @IBOutlet var scanView: UIView!
    @IBOutlet var followCodeTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var searchByScan: Bool = true
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    lazy var loaderManager = LoaderViewManager()
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Suivre un envoi"
        self.setCloseButton()
        
        self.searchButton.isEnabled = false
        self.searchButton.setTitleColor(UIColor.lpGrey, for: .normal)
        self.followCodeTextField.addTarget(self, action: #selector(ScanFollowCodeViewController.searchButtonChanged), for: .editingChanged)
        
        guard let captureDevice = self.findCamera() else {
            Logger.shared.debug("Failed to get the camera device")
            return
        }
        
        if UserDefaults.standard.bool(forKey: "scan.follow.first.opening") == true {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                // already authorized
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if !granted {
                        let askingPermissionController = UIAlertController(title: "Demande d'accès à la caméra", message: "Merci d'activer la caméra dans les réglages de l'application afin d'utiliser la camera", preferredStyle: .alert)
                        let closeAction = UIAlertAction(title: "Fermer", style: .cancel, handler: nil)
                        let settingsAction = UIAlertAction(title: "Accéder aux réglages", style: .default, handler: { _ in
                            if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        })
                        askingPermissionController.addAction(closeAction)
                        askingPermissionController.addAction(settingsAction)
                        self.present(askingPermissionController, animated: true, completion: nil)
                    }
                })
            }
        } else {
            let userDefaultsCamera = UserDefaults.standard
            userDefaultsCamera.set(true, forKey: "scan.follow.first.opening")
            userDefaultsCamera.synchronize()
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.removeInput(input)
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        } catch {
            Logger.shared.debug(error.localizedDescription)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.frame = self.scanView.layer.bounds
        
        self.scanView.layer.addSublayer(self.videoPreviewLayer!)
        
        // Start video capture.
        self.captureSession.startRunning()
        self.scanView.bringSubview(toFront: self.scanBar)
        self.scanBarActive()
    }
    
    override func viewDidLayoutSubviews() {
        self.videoPreviewLayer?.frame = self.scanView.layer.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleanSearch()
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kNewTracking,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kTrackingLevel)
    }
    
    func setCloseButton() {
        let closeBarButton = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(ScanFollowCodeViewController.closeModal))
        closeBarButton.tintColor = UIColor.lpGrey
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    @objc func closeModal() {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func findCamera() -> AVCaptureDevice? {
        for device in AVCaptureDevice.devices() {
            if (device as AnyObject).hasMediaType(AVMediaType.video) {
                if (device as AnyObject).position == AVCaptureDevice.Position.back {
                    return device
                }
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func cleanSearch() {
        self.searchByScan = true
        self.scanBarActive()
        self.captureSession.startRunning()
        self.followCodeTextField.text = ""
    }
    
    func scanBarActive() {
        if self.captureSession.isRunning == false {
            self.scanBar.layer.removeAllAnimations()
            self.scanBar.backgroundColor = UIColor.lpPurple
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.scanBar.alpha = 0.2
            }, completion: nil)
        }
    }
    
    func scanBarFound() {
        self.scanBar.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5, animations: {
            self.scanBar.alpha = 1.0
            self.scanBar.backgroundColor = UIColor.green
        })
    }
    
    func checkFollowCode(_ code: String) {
        self.loaderManager.showLoderView()
        TrackManager.shared.setHost("https://www.laposte.fr")
        TrackManager.shared.getShipmentFor(trackCode: code, completion: { success, responseFollow in
            self.loaderManager.hideLoaderView()
            if responseFollow != nil, success {
                self.searchByScan = false
                _ = CacheShipmentTrack.save(responseTrack: responseFollow!)
                let viewController = R.storyboard.follow.followDetailViewControllerID()!
                viewController.responseTrack = responseFollow
                self.navigationController?.pushViewController(viewController, animated: true)
                self.errorLabel.text = ""
                return
            } else if responseFollow != nil, !success {
                self.errorLabel.text = Constants.trackErrorLabelText
            } else {
                let alert = UIAlertController(title: "Erreur", message: "Problème connexion serveur.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { _ in
                    self.cleanSearch()
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        view.endEditing(true)
        if let text = self.followCodeTextField.text {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kRechercherNumero,
                                                                  pageName: TaggingData.kNewTracking,
                                                                  chapter1: nil,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTrackingLevel)
            
            self.checkFollowCode(text)
        }
    }
    
    @objc func searchButtonChanged() {
        if self.followCodeTextField.text == "" {
            self.searchButton.isEnabled = false
            self.searchButton.setTitleColor(UIColor.lpGrey, for: .normal)
        } else {
            self.searchButton.isEnabled = true
            self.searchButton.setTitleColor(UIColor.lpPurple, for: .normal)
        }
    }
}

extension ScanFollowCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.isEmpty {
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if self.supportedCodeTypes.contains(metadataObj.type), self.searchByScan {
            if metadataObj.stringValue != nil {
                self.captureSession.stopRunning()
                self.scanBarFound()
                self.searchByScan = false
                self.followCodeTextField.text = metadataObj.stringValue
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.checkFollowCode(metadataObj.stringValue!)
            }
        }
    }
}
