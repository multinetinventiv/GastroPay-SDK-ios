***REMOVED***
***REMOVED***  ServerTrustPolicy.swift
***REMOVED***
***REMOVED***  Copyright (c) 2014 Alamofire Software Foundation (http:***REMOVED***alamofire.org/)
***REMOVED***
***REMOVED***  Permission is hereby granted, free of charge, to any person obtaining a copy
***REMOVED***  of this software and associated documentation files (the "Software"), to deal
***REMOVED***  in the Software without restriction, including without limitation the rights
***REMOVED***  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
***REMOVED***  copies of the Software, and to permit persons to whom the Software is
***REMOVED***  furnished to do so, subject to the following conditions:
***REMOVED***
***REMOVED***  The above copyright notice and this permission notice shall be included in
***REMOVED***  all copies or substantial portions of the Software.
***REMOVED***
***REMOVED***  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
***REMOVED***  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
***REMOVED***  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
***REMOVED***  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
***REMOVED***  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
***REMOVED***  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
***REMOVED***  THE SOFTWARE.
***REMOVED***

import Foundation

***REMOVED***/ Responsible for managing the mapping of `ServerTrustPolicy` objects to a given host.
open class ServerTrustPolicyManager {
    ***REMOVED***/ The dictionary of policies mapped to a particular host.
    public let policies: [String: ServerTrustPolicy]

    ***REMOVED***/ Initializes the `ServerTrustPolicyManager` instance with the given policies.
    ***REMOVED***/
    ***REMOVED***/ Since different servers and web services can have different leaf certificates, intermediate and even root
    ***REMOVED***/ certficates, it is important to have the flexibility to specify evaluation policies on a per host basis. This
    ***REMOVED***/ allows for scenarios such as using default evaluation for host1, certificate pinning for host2, public key
    ***REMOVED***/ pinning for host3 and disabling evaluation for host4.
    ***REMOVED***/
    ***REMOVED***/ - parameter policies: A dictionary of all policies mapped to a particular host.
    ***REMOVED***/
    ***REMOVED***/ - returns: The new `ServerTrustPolicyManager` instance.
    public init(policies: [String: ServerTrustPolicy]) {
        self.policies = policies
    }

    ***REMOVED***/ Returns the `ServerTrustPolicy` for the given host if applicable.
    ***REMOVED***/
    ***REMOVED***/ By default, this method will return the policy that perfectly matches the given host. Subclasses could override
    ***REMOVED***/ this method and implement more complex mapping implementations such as wildcards.
    ***REMOVED***/
    ***REMOVED***/ - parameter host: The host to use when searching for a matching policy.
    ***REMOVED***/
    ***REMOVED***/ - returns: The server trust policy for the given host if found.
    open func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return policies[host]
    }
}

***REMOVED*** MARK: -

extension URLSession {
    private struct AssociatedKeys {
        static var managerKey = "URLSession.ServerTrustPolicyManager"
    }

    var serverTrustPolicyManager: ServerTrustPolicyManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.managerKey) as? ServerTrustPolicyManager
        }
        set (manager) {
            objc_setAssociatedObject(self, &AssociatedKeys.managerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

***REMOVED*** MARK: - ServerTrustPolicy

***REMOVED***/ The `ServerTrustPolicy` evaluates the server trust generally provided by an `NSURLAuthenticationChallenge` when
***REMOVED***/ connecting to a server over a secure HTTPS connection. The policy configuration then evaluates the server trust
***REMOVED***/ with a given set of criteria to determine whether the server trust is valid and the connection should be made.
***REMOVED***/
***REMOVED***/ Using pinned certificates or public keys for evaluation helps prevent man-in-the-middle (MITM) attacks and other
***REMOVED***/ vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged
***REMOVED***/ to route all communication over an HTTPS connection with pinning enabled.
***REMOVED***/
***REMOVED***/ - performDefaultEvaluation: Uses the default server trust evaluation while allowing you to control whether to
***REMOVED***/                             validate the host provided by the challenge. Applications are encouraged to always
***REMOVED***/                             validate the host in production environments to guarantee the validity of the server's
***REMOVED***/                             certificate chain.
***REMOVED***/
***REMOVED***/ - performRevokedEvaluation: Uses the default and revoked server trust evaluations allowing you to control whether to
***REMOVED***/                             validate the host provided by the challenge as well as specify the revocation flags for
***REMOVED***/                             testing for revoked certificates. Apple platforms did not start testing for revoked
***REMOVED***/                             certificates automatically until iOS 10.1, macOS 10.12 and tvOS 10.1 which is
***REMOVED***/                             demonstrated in our TLS tests. Applications are encouraged to always validate the host
***REMOVED***/                             in production environments to guarantee the validity of the server's certificate chain.
***REMOVED***/
***REMOVED***/ - pinCertificates:          Uses the pinned certificates to validate the server trust. The server trust is
***REMOVED***/                             considered valid if one of the pinned certificates match one of the server certificates.
***REMOVED***/                             By validating both the certificate chain and host, certificate pinning provides a very
***REMOVED***/                             secure form of server trust validation mitigating most, if not all, MITM attacks.
***REMOVED***/                             Applications are encouraged to always validate the host and require a valid certificate
***REMOVED***/                             chain in production environments.
***REMOVED***/
***REMOVED***/ - pinPublicKeys:            Uses the pinned public keys to validate the server trust. The server trust is considered
***REMOVED***/                             valid if one of the pinned public keys match one of the server certificate public keys.
***REMOVED***/                             By validating both the certificate chain and host, public key pinning provides a very
***REMOVED***/                             secure form of server trust validation mitigating most, if not all, MITM attacks.
***REMOVED***/                             Applications are encouraged to always validate the host and require a valid certificate
***REMOVED***/                             chain in production environments.
***REMOVED***/
***REMOVED***/ - disableEvaluation:        Disables all evaluation which in turn will always consider any server trust as valid.
***REMOVED***/
***REMOVED***/ - customEvaluation:         Uses the associated closure to evaluate the validity of the server trust.
public enum ServerTrustPolicy {
    case performDefaultEvaluation(validateHost: Bool)
    case performRevokedEvaluation(validateHost: Bool, revocationFlags: CFOptionFlags)
    case pinCertificates(certificates: [SecCertificate], validateCertificateChain: Bool, validateHost: Bool)
    case pinPublicKeys(publicKeys: [SecKey], validateCertificateChain: Bool, validateHost: Bool)
    case disableEvaluation
    case customEvaluation((_ serverTrust: SecTrust, _ host: String) -> Bool)

    ***REMOVED*** MARK: - Bundle Location

    ***REMOVED***/ Returns all certificates within the given bundle with a `.cer` file extension.
    ***REMOVED***/
    ***REMOVED***/ - parameter bundle: The bundle to search for all `.cer` files.
    ***REMOVED***/
    ***REMOVED***/ - returns: All certificates within the given bundle.
    public static func certificates(in bundle: Bundle = Bundle.main) -> [SecCertificate] {
        var certificates: [SecCertificate] = []

        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
        }.joined())

        for path in paths {
            if
                let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
                let certificate = SecCertificateCreateWithData(nil, certificateData)
            {
                certificates.append(certificate)
            }
        }

        return certificates
    }

    ***REMOVED***/ Returns all public keys within the given bundle with a `.cer` file extension.
    ***REMOVED***/
    ***REMOVED***/ - parameter bundle: The bundle to search for all `*.cer` files.
    ***REMOVED***/
    ***REMOVED***/ - returns: All public keys within the given bundle.
    public static func publicKeys(in bundle: Bundle = Bundle.main) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for certificate in certificates(in: bundle) {
            if let publicKey = publicKey(for: certificate) {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    ***REMOVED*** MARK: - Evaluation

    ***REMOVED***/ Evaluates whether the server trust is valid for the given host.
    ***REMOVED***/
    ***REMOVED***/ - parameter serverTrust: The server trust to evaluate.
    ***REMOVED***/ - parameter host:        The host of the challenge protection space.
    ***REMOVED***/
    ***REMOVED***/ - returns: Whether the server trust is valid.
    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        var serverTrustIsValid = false

        switch self {
        case let .performDefaultEvaluation(validateHost):
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            serverTrustIsValid = trustIsValid(serverTrust)
        case let .performRevokedEvaluation(validateHost, revocationFlags):
            let defaultPolicy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            let revokedPolicy = SecPolicyCreateRevocation(revocationFlags)
            SecTrustSetPolicies(serverTrust, [defaultPolicy, revokedPolicy] as CFTypeRef)

            serverTrustIsValid = trustIsValid(serverTrust)
        case let .pinCertificates(pinnedCertificates, validateCertificateChain, validateHost):
            if validateCertificateChain {
                let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
                SecTrustSetPolicies(serverTrust, policy)

                SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
                SecTrustSetAnchorCertificatesOnly(serverTrust, true)

                serverTrustIsValid = trustIsValid(serverTrust)
            } else {
                let serverCertificatesDataArray = certificateData(for: serverTrust)
                let pinnedCertificatesDataArray = certificateData(for: pinnedCertificates)

                outerLoop: for serverCertificateData in serverCertificatesDataArray {
                    for pinnedCertificateData in pinnedCertificatesDataArray {
                        if serverCertificateData == pinnedCertificateData {
                            serverTrustIsValid = true
                            break outerLoop
                        }
                    }
                }
            }
        case let .pinPublicKeys(pinnedPublicKeys, validateCertificateChain, validateHost):
            var certificateChainEvaluationPassed = true

            if validateCertificateChain {
                let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
                SecTrustSetPolicies(serverTrust, policy)

                certificateChainEvaluationPassed = trustIsValid(serverTrust)
            }

            if certificateChainEvaluationPassed {
                outerLoop: for serverPublicKey in ServerTrustPolicy.publicKeys(for: serverTrust) as [AnyObject] {
                    for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
                        if serverPublicKey.isEqual(pinnedPublicKey) {
                            serverTrustIsValid = true
                            break outerLoop
                        }
                    }
                }
            }
        case .disableEvaluation:
            serverTrustIsValid = true
        case let .customEvaluation(closure):
            serverTrustIsValid = closure(serverTrust, host)
        }

        return serverTrustIsValid
    }

    ***REMOVED*** MARK: - Private - Trust Validation

    private func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false

        if #available(iOS 12, macOS 10.14, tvOS 12, watchOS 5, *) {
            isValid = SecTrustEvaluateWithError(trust, nil)
        } else {
            var result = SecTrustResultType.invalid
            let status = SecTrustEvaluate(trust, &result)

            if status == errSecSuccess {
                let unspecified = SecTrustResultType.unspecified
                let proceed = SecTrustResultType.proceed

                isValid = result == unspecified || result == proceed
            }
        }

        return isValid
    }

    ***REMOVED*** MARK: - Private - Certificate Data

    private func certificateData(for trust: SecTrust) -> [Data] {
        var certificates: [SecCertificate] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.append(certificate)
            }
        }

        return certificateData(for: certificates)
    }

    private func certificateData(for certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
    }

    ***REMOVED*** MARK: - Private - Public Key Extraction

    private static func publicKeys(for trust: SecTrust) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if
                let certificate = SecTrustGetCertificateAtIndex(trust, index),
                let publicKey = publicKey(for: certificate)
            {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    private static func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }
}
