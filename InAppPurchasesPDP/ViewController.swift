//
//  ViewController.swift
//  InAppPurchasesPDP
//
//  Created by Никита Лужбин on 12.06.2021.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    // MARK: - Nested Types

    enum Product: String, CaseIterable {

        // MARK: - Enumeration Cases

        case tenGems = "com.dest.InAppPurchasesPDP.tenGems"
        case contentSubscription = "com.dest.InAppPurchasesPDP.contentSubscription"
        case removeAdd = "com.dest.InAppPurchasesPDP.removeAdds"
    }

    enum UserDefaultsKey {

        // MARK: - Type Properties

        static let gemsAmount = "gemsAmount"
        static let isSubscriptionPurchased = "isSubscriptionPurchased"
        static let isAddDisabled = "isAddDisabled"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var gemsAmountLabel: UILabel!

    // MARK: -

    private var products: [SKProduct] = []

    // MARK: - Initialize

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitialState()
        self.fetchProducts()
    }

    // MARK: - Insance Methods

    @IBAction private func onRemoveAddsButtonTouchUpInside(_ sender: Any) {
        self.purchase(.removeAdd)
    }
    
    @IBAction private func onGetSubscriptionButtonTouchUpInside(_ sender: UIButton) {
        self.purchase(.contentSubscription)
    }

    @IBAction private func onGetGemsButtonTouchUpInside(_ sender: UIButton) {
        self.purchase(.tenGems)
    }

    @IBAction func onClearPurchasesTouchUpInside(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isAddDisabled)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isSubscriptionPurchased)
        UserDefaults.standard.set(0, forKey: UserDefaultsKey.gemsAmount)

        self.setupInitialState()
    }
    
    // MARK: -

    private func setupInitialState() {
        self.gemsAmountLabel.text = String(UserDefaults.standard.integer(forKey: UserDefaultsKey.gemsAmount))
    }

    private func fetchProducts() {
        let productsSet = Set(Product.allCases.compactMap({ $0.rawValue }))

        let request = SKProductsRequest(productIdentifiers: productsSet)

        request.delegate = self
        request.start()
    }

    private func purchase(_ product: Product) {
        switch product {
        case .contentSubscription:
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.isSubscriptionPurchased) {
                self.showAlert(title: "Error", message: "Allready Purchased")
                return
            }

        case .removeAdd:
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.isAddDisabled) {
                self.showAlert(title: "Error", message: "Allready Purchased")
                return
            }

        default:
            break
        }

        guard let product = self.products.first(where: { $0.productIdentifier == product.rawValue }) else {
            return
        }

        let payment = SKPayment(product: product)

        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }

    private func productDidPurchased(_ product: Product) {
        switch product {
        case .tenGems:
            let currentGemsAmount = UserDefaults.standard.integer(forKey: UserDefaultsKey.gemsAmount)
            UserDefaults.standard.set(currentGemsAmount + 10, forKey: UserDefaultsKey.gemsAmount)
            self.gemsAmountLabel.text = String(currentGemsAmount + 10)
            
        case .removeAdd:
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isAddDisabled)

        case .contentSubscription:
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isSubscriptionPurchased)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - SKProductsRequestDelegate

extension ViewController: SKProductsRequestDelegate {

    // MARK: - Instance Methods

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
}

// MARK: - SKPaymentTransactionObserver

extension ViewController: SKPaymentTransactionObserver {

    // MARK: - Instance Methods

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {

            case .purchasing:
                break

            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)

            case .restored, .purchased:
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)

                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    self.productDidPurchased(product)
                }

            @unknown default:
                break
            }
        }
    }
}
