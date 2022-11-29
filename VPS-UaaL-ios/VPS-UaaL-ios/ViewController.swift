//
//  ViewController.swift
//  VPS-UaaL-ios
//
//  Created by Yoshikazu Kuramochi on 2022/11/24.
//

import UIKit
import UnityFramework

class ViewController: UIViewController, UnityFrameworkListener {

    private var infoTextView: UITextView?
    private var snackBarTextView: UITextView?
    private var debugTextView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startUnity(_ sender: Any) {
        let ufw = loadUnityFramework()
        ufw.setDataBundleId("com.unity3d.framework")
        ufw.register(self)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: appDelegate.appLaunchOpts)

        if let view = ufw.appController()?.rootView {
            infoTextView = createTextView(view, CGRectMake(150, 50, view.frame.width - 150, 120))
            snackBarTextView = createTextView(view, CGRectMake(10, view.frame.height - 120, view.frame.width - 20, 100))
            debugTextView = createTextView(view, CGRectMake(150, view.frame.height - 350, view.frame.width - 150, 200))
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

    private func createTextView(_ view: UIView, _ frame: CGRect) -> UITextView {
        let textView = UITextView()
        textView.frame = frame
        textView.textColor = .white
        textView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(textView)
        return textView
    }
}

