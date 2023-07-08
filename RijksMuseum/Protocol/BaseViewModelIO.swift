//
//  BaseViewModelIO.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit
import SwiftMessages

struct RijksMuseumAlert: Equatable {
    var title: String
    var subtitle: String
}

protocol BaseDisplayLogic: AnyObject {
    func handle(error: RijksMuseumError)
    func showError(error: Error)
    func showAlert(alert: RijksMuseumAlert)
}

protocol Loading {
    func showLoading()
    func hideLoading()
}

protocol BaseViewModelOutput: BaseDisplayLogic, Loading { }

extension BaseDisplayLogic where Self: UIViewController {

    @MainActor
    func handle(error: RijksMuseumError) {
        showError(error: error)
    }

    @MainActor
    func showError(error: Error) {
        showError(title: Strings.commonGeneralError.localized, subtitle: error.localizedDescription)
    }

    @MainActor
    func showError(title: String, subtitle: String) {
        showAlert(alert: RijksMuseumAlert(title: title, subtitle: subtitle))
    }

    @MainActor
    func showAlert(alert: RijksMuseumAlert) {
        showAlert(title: alert.title, subtitle: alert.subtitle, theme: .error)
    }

    @MainActor
    func showAlert(title: String, subtitle: String?, theme: Theme) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.button?.isHidden = true
        view.configureContent(title: title, body: subtitle ?? "")

        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.preferredStatusBarStyle = .lightContent
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)

        SwiftMessages.show(config: successConfig, view: view)
    }
}

extension UIViewController: BaseViewModelOutput {

    @MainActor
    func showLoading() {
        view.showLoadingIndicator()
    }

    @MainActor
    func hideLoading() {
        view.dismissLoadingIndicator()
    }
}
