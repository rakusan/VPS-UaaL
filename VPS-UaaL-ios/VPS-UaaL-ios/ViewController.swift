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

    private var clearAllButton: UIButton?
    private var setAnchorButton: UIButton?


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
            infoTextView = createTextView(parent: view, frame: CGRectMake(150, 50, view.frame.width - 150, 120))
            snackBarTextView = createTextView(parent: view, frame: CGRectMake(10, view.frame.height - 120, view.frame.width - 20, 100))
            debugTextView = createTextView(parent: view, frame: CGRectMake(150, view.frame.height - 350, view.frame.width - 150, 200))

            clearAllButton = createButton(parent: view, frame: CGRectMake(10, view.frame.height - 200, 120, 50),
                                          title: "CLEAR ALL ANCHORS", numberOfLines: 2) { /* TODO */ }
            setAnchorButton = createButton(parent: view, frame: CGRectMake(10, view.frame.height - 260, 120, 50),
                                           title: "SET ANCHOR") { /* TODO */ }
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
}

