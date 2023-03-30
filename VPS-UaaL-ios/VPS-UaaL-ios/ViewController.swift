//
//  ViewController.swift
//  VPS-UaaL-ios
//
//  Created by Yoshikazu Kuramochi on 2022/11/24.
//

import UIKit
import MapKit
import UnityFramework

class ViewController: UIViewController, UnityFrameworkListener, NativeCallsProtocol {

    private var ufw: UnityFramework!

    private var mapView: MKMapView!
    private var infoTextView: UITextView!
    private var snackBarTextView: UITextView!
    //private var debugTextView: UITextView!

    //private var clearAllButton: UIButton!
    //private var setAnchorButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startUnity(_ sender: Any) {
        ufw = loadUnityFramework()
        ufw.setDataBundleId("com.unity3d.framework")
        ufw.register(self)
        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: appDelegate.appLaunchOpts)

        if let view = ufw.appController()?.rootView {
            mapView = MKMapView(frame: CGRect(x: 0, y: view.frame.height/3*2, width: view.frame.width, height: view.frame.height/3))
            mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
            view.addSubview(mapView)

            infoTextView = createTextView(parent: view, frame: CGRectMake(150, 50, view.frame.width - 150, 120))
            snackBarTextView = createTextView(parent: view, frame: CGRectMake(10, view.frame.height - 45, view.frame.width - 20, 25))
            //debugTextView = createTextView(parent: view, frame: CGRectMake(150, view.frame.height - 350, view.frame.width - 150, 200))

            //clearAllButton = createButton(parent: view, frame: CGRectMake(10, view.frame.height - 200, 120, 50),
            //                              title: "CLEAR ALL ANCHORS", numberOfLines: 2) { self.clearAllAnchors() }
            //setAnchorButton = createButton(parent: view, frame: CGRectMake(10, view.frame.height - 260, 120, 50),
            //                               title: "SET ANCHOR") { self.setAnchor() }
        }
    }

    private func loadUnityFramework() -> UnityFramework {
        let bundlePath = Bundle.main.bundlePath.appending("/Frameworks/UnityFramework.framework")
        let bundle = Bundle(path: bundlePath)!
        if !bundle.isLoaded {
            bundle.load()
        }

        let ufw = bundle.principalClass!.getInstance()!
        if (ufw.appController() == nil) {
            // unity is not initialized
            var header = _mh_execute_header
            ufw.setExecuteHeader(&header)
        }
        return ufw
    }

    private func createTextView(parent: UIView, frame: CGRect) -> UITextView {
        let textView = UITextView()
        textView.frame = frame
        textView.textColor = .white
        textView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        textView.isEditable = false
        parent.addSubview(textView)
        return textView
    }

    private func createButton(parent: UIView, frame: CGRect, title: String, numberOfLines: Int = 1, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.frame = frame
        button.addAction(.init { _ in action() }, for: .primaryActionTriggered)
        button.backgroundColor = .white
        button.isHidden = true
        button.titleLabel?.numberOfLines = numberOfLines
        parent.addSubview(button)
        return button
    }

    private func clearAllAnchors() {
        ufw.sendMessageToGO(withName: "GeospatialController", functionName: "OnClearAllClicked", message: "")
    }

    private func setAnchor() {
        ufw.sendMessageToGO(withName: "GeospatialController", functionName: "OnSetAnchorClicked", message: "")
    }

    func updateInfoText(_ infoText: String!) {
        infoTextView.text = infoText
    }

    func updateLocation(_ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        if let annotation = mapView.annotations.first(where: { $0 is MKPointAnnotation }) as? MKPointAnnotation {
            annotation.coordinate = coordinate
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

    func updateSnackBarText(_ snackBarText: String!) {
        snackBarTextView.text = snackBarText
    }

    func updateDebugText(_ debugText: String!) {
        //debugTextView.text = debugText
    }

    func clearAllButtonSetActive(_ active: Bool) {
        //clearAllButton.isHidden = !active
    }

    func setAnchorButtonSetActive(_ active: Bool) {
        //setAnchorButton.isHidden = !active
    }

    func debugTextSetActive(_ active: Bool) {
        //debugTextView.isHidden = !active
    }
}

