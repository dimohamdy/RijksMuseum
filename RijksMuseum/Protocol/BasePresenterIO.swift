//
//  BasePresenterIO.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit
//import SwiftMessages

protocol BasePresenterInput: AnyObject {
    func viewDidLoad()
}

extension BasePresenterInput {
    func viewDidLoad() {}
}

protocol BaseDisplayLogic: AnyObject {
    func handle(error: RijksMuseumError)
    func showError(error: Error)
    func showError(title: String, subtitle: String?)
    func showSuccess(title: String, subtitle: String?)
}

protocol Loading {
    func showLoading()
    func hideLoading()
}

protocol BasePresenterOutput: BaseDisplayLogic, Loading { }

extension BaseDisplayLogic where Self: UIViewController {

    func handle(error: RijksMuseumError) {
        showError(error: error)
    }
    
    func showError(error: Error) {
        showError(title: Strings.commonGeneralError.localized(), subtitle: error.localizedDescription)
    }
    
    func showError(title: String, subtitle: String?) {
//        showAlert(title: title, subtitle: subtitle, theme: .error)
    }

    func showSuccess(title: String, subtitle: String?) {
//        showAlert(title: title, subtitle: subtitle, theme: .success)
    }

//    func showAlert(title: String, subtitle: String?, theme: Theme) {
//        DispatchQueue.main.async {
//
//            let view = MessageView.viewFromNib(layout: .cardView)
//            view.configureTheme(theme)
//            view.button?.isHidden = true
//            view.configureContent(title: title, body: subtitle ?? "")
//
//            var successConfig = SwiftMessages.defaultConfig
//            successConfig.presentationStyle = .center
//            successConfig.preferredStatusBarStyle = .lightContent
//            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
//
//            SwiftMessages.show(config: successConfig, view: view)
//        }
//    }
}

extension UIViewController: BasePresenterOutput {

    func showLoading() {
        DispatchQueue.main.async {
            self.view.showLoadingIndicator()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.view.dismissLoadingIndicator()
        }
    }
}
