//
//  BasePresenterIO.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

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
        showAlert(title: title, subtitle: subtitle)
    }

    func showAlert(title: String, subtitle: String?) {
        DispatchQueue.main.async {

            let alert = UIAlertController(title: title, message: subtitle,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: Strings.okAction.localized(), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
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
