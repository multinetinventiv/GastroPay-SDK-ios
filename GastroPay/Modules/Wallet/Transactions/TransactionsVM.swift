***REMOVED***
***REMOVED***  TransactionsViewModel.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import Foundation

class TransactionsVM: NSObject {
    let transactionsView = TransactionsView()
    
    let transactionsTotalEarningsView = TransactionsTotalEarningsView()
    let transactionsTableView = MIStackTableView()
    var walletTransactionSummary: NetworkModels.WalletTransactionSummary?
    var walletTransactions: [WalletTransaction] = []
    
    let totalEarningsIcon = ImageHelper.Wallet.headerPuanIconDark
    let totalEarningsValueDefaultTextColor = ColorHelper.activeColor
    let totalEarningsText = Localization.Wallet.detailHeaderText.local
    let totalEarningsTextFont = FontHelper.Wallet.PuanDetail.puanBottomText
    let totalEarningsPuanValueFont = FontHelper.Wallet.PuanDetail.puanValue
    let totalEarningsPuanCurrencyFont = FontHelper.Wallet.PuanDetail.puanCurrency
    
    let evenCellBackgroundColor = ColorHelper.Wallet.Transaction.backgroundColorForEvenCells
    let oddCellBackgroundColor = ColorHelper.Wallet.Transaction.backgroundColorForOddCells
    let transactionCellMerchantTextColor = ColorHelper.Wallet.Transaction.walletCellMerchantName
    let transactionCellMerchantTextFont = FontHelper.lightTextFont(size: 14)
    let transactionCellAmountTextColor = ColorHelper.Wallet.Transaction.walletCellAmountTextColor
    let transactionCellAmountTextFont = FontHelper.mediumTextFont(size: 17)
    let transactionCellTransactionTypeTextFont = FontHelper.regularTextFont(size: 12)
    let transactionCellDateFont = FontHelper.lightTextFont(size: 12)
    let transactionCellDateTextColor = ColorHelper.Wallet.Transaction.walletCellDateTextColor
    let transactionCellImage = ImageHelper.Icons.chevronRight

    let transactionCellDepositTextColor = ColorHelper.Wallet.Transaction.walletCellDepositTextColor
    let transactionCellDepositText = Localization.Wallet.depositText.local
    let transactionCellWithdrawTextColor = ColorHelper.Wallet.Transaction.walletCellWithdrawTextColor
    let transactionCellWithdrawText = Localization.Wallet.withdrawText.local
    let transactionCellCancelTextColor = ColorHelper.Wallet.Transaction.walletCellCancelTextColor
    let transactionCellCancelText = Localization.Wallet.cancelText.local
    
    let sectionHeaderHeight = CGFloat(54)
    let headerText = Localization.Wallet.transactionTitle.local
    let headerTextColor = ColorHelper.Wallet.Transaction.transactionTitle
    let headerFont = FontHelper.lightTextFont(size: 14)

    let networkDispatchGroup = DispatchGroup()

    var onSetLoadingIndicator: ((Bool)->())?
    var onSelectTransaction: ((WalletTransaction)->())?

    init(onSetLoadingIndicator: ((Bool)->())?, onTappedClose: (() -> ())?, onTappedSettings: (() -> ())?) {
        super.init()
        
        self.onSetLoadingIndicator = onSetLoadingIndicator
        self.transactionsView.onTappedClose = onTappedClose
        self.transactionsView.onTappedSettings = onTappedSettings

        self.transactionsTableView.delegate = self
        self.transactionsTableView.dataSource = self
        self.transactionsTableView.register(TransactionCell.self)
    }
    
    public func setupView(vc: MIViewController) {
        vc.view.backgroundColor = .white
        
        transactionsTotalEarningsView.puanIcon.image = totalEarningsIcon
        transactionsTotalEarningsView.totalEarningsValueLabel.textColor = totalEarningsValueDefaultTextColor
        transactionsTotalEarningsView.totalEarningsTextLabel.text = totalEarningsText
        transactionsTotalEarningsView.totalEarningsTextLabel.font = totalEarningsTextFont
        transactionsTotalEarningsView.totalEarningsPuanValueFont = totalEarningsPuanValueFont
        transactionsTotalEarningsView.totalEarningsPuanCurrencyFont = totalEarningsPuanCurrencyFont

        transactionsView.setupView()

        vc.view.addSubview(transactionsView)
        transactionsView.bindFrameToSuperviewBounds()
    }
    
    public func fetchTransactions() {
        onSetLoadingIndicator?(true)
        
        fetchWalletSummary()
        fetchWalletTransactions()
        
        networkDispatchGroup.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            defer { self.onSetLoadingIndicator?(false) }

            if let walletTransactionSummary = self.walletTransactionSummary {
                if self.transactionsTotalEarningsView.superview == nil {
                    self.transactionsView.stackView.addRow(self.transactionsTotalEarningsView, animated: true)
                    self.transactionsView.stackView.setInset(forRow: self.transactionsTotalEarningsView, inset: .zero)
                }

                self.transactionsTotalEarningsView.updateTotalEarnings(with: walletTransactionSummary)
            }

            if self.transactionsTableView.superview == nil, self.walletTransactions.count > 0 {
                self.transactionsView.stackView.addRow(self.transactionsTableView, animated: true)
                self.transactionsView.stackView.setInset(forRow: self.transactionsTableView, inset: .zero)
            }
        }
    }
    
    private func fetchWalletSummary() {
        networkDispatchGroup.enter()

        Service.getAPI()?.getWalletTransactionSummary {[weak self] (result) in
            guard let self = self else { return }

            defer { self.networkDispatchGroup.leave() }

            switch result {
            case .success(let summary):
                self.walletTransactionSummary = summary
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }

    private func fetchWalletTransactions() {
        networkDispatchGroup.enter()

        guard (Service.getAuthenticationManager()?.user) != nil else {
            Gastropay.getUser() {
                self.getWalletTransactions()
            }
            
            return
        }
        
        self.getWalletTransactions()
    }
    
    private func getWalletTransactions() {
        guard let walletUUID = Service.getAuthenticationManager()?.user?.walletUId else { return }
        
        Service.getAPI()?.getWalletTransactions(walletUUID: walletUUID, endTimestamp: Int(Date().timeIntervalSince1970)) {[weak self] (result) in
            guard let self = self else { return }
            
            defer { self.networkDispatchGroup.leave() }
            
            switch result {
            case .success(let walletTransactions):
                self.walletTransactions = walletTransactions
                self.transactionsTableView.reloadData()
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
}

extension TransactionsVM: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TransactionCell.self)
        setupCell(cell: cell, transaction: self.walletTransactions[indexPath.row])
        cell.configure(for: self.walletTransactions[indexPath.row])
        cell.backgroundColor = indexPath.row % 2 == 0 ? evenCellBackgroundColor : oddCellBackgroundColor
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletTransactions.count
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectTransaction?(walletTransactions[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let transactionHeader = TransactionHeader.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight))
        transactionHeader.headerTextLabel.text = headerText
        transactionHeader.headerTextLabel.textColor = headerTextColor
        transactionHeader.headerTextLabel.font = headerFont

        return transactionHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    private func setupCell(cell: TransactionCell, transaction: WalletTransaction) {
        cell.merchant.font = transactionCellMerchantTextFont
        cell.merchant.textColor = transactionCellMerchantTextColor
        cell.amount.font = transactionCellAmountTextFont
        cell.amount.textColor = transactionCellAmountTextColor
        cell.transactionType.font = transactionCellTransactionTypeTextFont

        cell.date.font = transactionCellDateFont
        cell.date.textColor = transactionCellDateTextColor
        cell.chevron.image = transactionCellImage
        
        switch transaction.walletTransactionType {
        
        case .Deposit:
            cell.transactionType.textColor = transactionCellDepositTextColor
            cell.transactionType.text = transactionCellDepositText
        case .Withdraw:
            cell.transactionType.textColor = transactionCellWithdrawTextColor
            cell.transactionType.text = transactionCellWithdrawText
        case .CancelDeposit, .CancelWithdraw:
            cell.transactionType.textColor = transactionCellCancelTextColor
            cell.transactionType.text = transactionCellCancelText
        }
    }
}

fileprivate class TransactionHeader: UIView {
    let headerTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerTextLabel)

        headerTextLabel.frame = CGRect.init(x: 16, y: 16, width: frame.width-16, height: frame.height-32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
