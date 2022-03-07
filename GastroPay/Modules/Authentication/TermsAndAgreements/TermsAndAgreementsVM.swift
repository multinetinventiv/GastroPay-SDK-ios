//
//  TermsAndAgreementsVM.swift
//  Authentication
//
//  Created by ilker sevim on 7.10.2020.
//

import Foundation


public enum TermsAndAgreementsContent {
    case contract
    case gdpr
    case clarification
}

public class TermsAndAgreementsVM {
    
    public var approveButtonText: String = "Onaylıyorum"
    public var title: String = "ŞARTLAR"
    public var isApproveButtonHidden: Bool = false
    
    public var registerButtonActiveBackgroundColor: UIColor!
    public var registerButtonDisabledBackgroundColor: UIColor!
    
    public var registerButtonActiveTextColor: UIColor!
    public var registerButtonDisabledTextColor: UIColor!
    
    public init() {}
}
