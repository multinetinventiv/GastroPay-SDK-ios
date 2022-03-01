***REMOVED***
***REMOVED***  PayWithQRVC.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***  Created by Hasan Hüseyin Gücüyener on 21.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import YPNavigationBarTransition
import Then
import AVFoundation
import NotificationCenter
import SnapKit

public class PayWithQRVC: MIViewController  {
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var captureDeviceInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var metadataOutput: AVCaptureMetadataOutput?
    
    var viewModel: PayWithQRVM!
    
    init(viewModel: PayWithQRVM? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = PayWithQRVM()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override public func viewDidLoad() {
        navigationItem.titleView = viewModel.payWithQRView.navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewModel.navigationRightImage, style: .done, target: self, action: #selector(tappedClose))
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        viewModel.setupView(vc: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCameraAndStartScan()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session?.stopRunning()
    }
    
    @objc func willEnterForeground() {
        checkCameraAndStartScan()
    }
    
    func checkCameraAndStartScan() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            startScan()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if(granted) {
                        self.startScan()
                    } else {
                        Service.getPopupManager()?.openCameraAuthorizationPopup()
                    }
                }
            })
        default:
            Service.getPopupManager()?.openCameraAuthorizationPopup()
        }
    }
    
    @objc func tappedClose() {
        self.dismiss(animated: true)
    }
    
    var alreadySent = false
    
    func startScan() {
        if self.session == nil {
            self.session = AVCaptureSession()
        }
        
        guard let session = self.session else {
            Service.getLogger()?.debug("Cannot initialize camera session")
            return
        }
        
        if !session.isRunning {
            if self.device == nil {
                self.device = AVCaptureDevice.default(for: .video)
            }
            
            guard let device = self.device else {
                Service.getLogger()?.debug("Cannot initialize camera device")
                #if targetEnvironment(simulator)
                if !alreadySent {
                    alreadySent = true
                }
                #endif
                return
            }
            
            if self.captureDeviceInput == nil {
                self.captureDeviceInput = try? AVCaptureDeviceInput(device: device)
                
                guard let captureDeviceInput = self.captureDeviceInput else {
                    Service.getLogger()?.debug("Cannot create capture device input")
                    return
                }
                
                session.addInput(captureDeviceInput)
            }
            
            if self.previewLayer == nil {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
                self.previewLayer!.videoGravity = .resizeAspectFill
                self.previewLayer!.frame = self.view.bounds
                viewModel.payWithQRView.cameraView.layer.addSublayer(self.previewLayer!)
            }
            
            if self.metadataOutput == nil {
                self.metadataOutput = AVCaptureMetadataOutput()
                self.session?.addOutput(self.metadataOutput!)
                self.metadataOutput?.metadataObjectTypes = [.qr]
                self.metadataOutput?.setMetadataObjectsDelegate(self, queue: .main)
            }
            
            self.session?.startRunning()
        }
    }
    
    func qrCodeFound(code: String) {
        view.setLoadingState(show: true)
        
        Service.getAPI()?.getPaymentInformation(qrCode: code, tokenType: .qr) {[weak self] (result) in
            guard let self = self else { return }
            defer { self.view.setLoadingState(show: false) }
            
            switch result {
            case .success(let paymentInformation):
                self.navigationController?.pushViewController(PaymentConfirmationVC(paymentInformation: paymentInformation, qrCode: code, tokenType: .qr), animated: true)
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }
}

extension PayWithQRVC: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            session?.stopRunning()
            qrCodeFound(code: stringValue)
        }
    }
}

extension PayWithQRVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .backgroundStyleTransparent
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .white
    }
}
