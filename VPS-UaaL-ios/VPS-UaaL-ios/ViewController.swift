//
//  ViewController.swift
//  VPS-UaaL-ios
//
//  Created by Yoshikazu Kuramochi on 2022/11/24.
//

import UIKit
import UnityFramework

class ViewController: UIViewController, UnityFrameworkListener {

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
}

