***REMOVED***
***REMOVED***  TransactionDetailVM.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***  Created by on 16.09.2021.
***REMOVED***

import Foundation

class TransactionDetailVM: NSObject {
    var transaction: WalletTransaction
    var transactionDetailView = TransactionDetailView()
    
    var navigationTitle = Localization.Wallet.TransactionDetail.navigationTitle.local
    var backgroundColor = UIColor.white
    var merchantLabel = Localization.Wallet.TransactionDetail.merchantLabel.local
    var amountLabel = Localization.Wallet.TransactionDetail.amountLabel.local
    var transactionTypeLabel = Localization.Wallet.TransactionDetail.transactionTypeLabel.local
    var dateLabel = Localization.Wallet.TransactionDetail.dateLabel.local

    var transactionContainerbackgroundColor = ColorHelper.Wallet.TransactionDetail.containerBackground
    var billContainerbackgroundColor = ColorHelper.Wallet.TransactionDetail.containerBackground
    var billLabelFont = FontHelper.Wallet.TransactionDetail.rowLabel
    var billLabelTextColor = ColorHelper.Wallet.TransactionDetail.labelColor
    var billValueFont = FontHelper.Wallet.TransactionDetail.rowLabel
    var billValueTextColor = ColorHelper.Wallet.TransactionDetail.labelColor
    var shareIconImage = ImageHelper.Icons.share
    
    var onSetLoadingState: ((Bool) -> ())? = nil

    init(transaction: WalletTransaction) {
        self.transaction = transaction
        
        super.init()
    }
    
    public func setupView(vc: MIViewController) {
        transactionDetailView.transactionInfoTableView.dataSource = self
        transactionDetailView.transactionInfoTableView.delegate = self
        
        transactionDetailView.setupView(transaction: self.transaction)
        vc.view.addSubview(transactionDetailView)
        transactionDetailView.bindFrameToSuperviewBounds()
        transactionDetailView.onTapShareIcon = tappedShareIcon
        transactionDetailView.billNumber.text = transaction.invoiceNumber
        
        transactionDetailView.transactionContainer.backgroundColor = transactionContainerbackgroundColor
        transactionDetailView.billContainer.backgroundColor = billContainerbackgroundColor

        transactionDetailView.billLabel.font = billLabelFont
        transactionDetailView.billLabel.textColor = billLabelTextColor
        transactionDetailView.billLabel.text = Localization.Wallet.TransactionDetail.billLabel.local
        transactionDetailView.billNumber.font = billValueFont
        transactionDetailView.billNumber.textColor = billValueTextColor
        transactionDetailView.shareIcon.image = shareIconImage
    }
    
    private func tappedShareIcon() {
        onSetLoadingState?(true)

        Service.getAPI()?.sendInvoice(id: transaction.id) { (result) in
            defer { self.onSetLoadingState?(false) }

            switch result {
            case .success(_):
                Service.getPopupManager()?.showCardMessage(theme: .success, body: Localization.Wallet.TransactionDetail.invoiceSent.local)
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }
}

extension TransactionDetailVM: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (transaction.walletTransactionDetails?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TransactionDetailCell.self)

        let transactionDetailCount = transaction.walletTransactionDetails?.count ?? 0

        if indexPath.row == 0 {
            cell.label.text = merchantLabel
            cell.value.text = transaction.merchantName
        } else if indexPath.row == 1 {
            cell.label.text = amountLabel
            cell.value.text = transaction.transactionAmount.displayValue
        } else if indexPath.row == 1 + transactionDetailCount {
            cell.label.text = transactionTypeLabel
            cell.value.text = transaction.walletTransactionType.toDisplayValue()
            cell.value.textColor = transaction.walletTransactionType.toDisplayColor()
        } else if indexPath.row == 2 + transactionDetailCount {
            cell.label.text = dateLabel
            let dateFormatter = DateFormatter().then { $0.dateFormat = "dd.MM.YYY - HH:mm" }
            cell.value.text = dateFormatter.string(from: transaction.transactionDate)
        }

        return cell
    }
}
