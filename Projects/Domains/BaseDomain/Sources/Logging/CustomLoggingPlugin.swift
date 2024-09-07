import Foundation
import Moya
import OSLog

#if DEBUG || QA
    private enum NetworkLogLevel: String {
        case short
        case detail
    }

    public final class CustomLoggingPlugin: PluginType {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "NETWORK")
        private let logLevel: NetworkLogLevel

        public init() {
            self.logLevel = CustomLoggingPlugin.getLogLevelFromArguments() ?? .detail
        }

        public func willSend(_ request: RequestType, target: TargetType) {
            guard let httpRequest = request.request else {
                print("--> 유효하지 않은 요청")
                return
            }
            let url = httpRequest.description
            let method = httpRequest.httpMethod ?? "unknown method"
            var log = "====================\n\n[\(method)] \(url)\n\n====================\n"
            log.append("API: \(target)\n")
            if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
                log.append("header: \(headers)\n")
            }
            if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
                log.append("\(bodyString)\n")
            }
            log.append("---------------- END \(method) -----------------------\n")

            switch logLevel {
            case .short:
                let log = "[🛜 Request] [\(method)] [\(target)] \(url)"
                logger.log(level: .debug, "\(log)")
            case .detail:
                logger.log(level: .debug, "\(log)")
            }
        }

        public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
            switch result {
            case let .success(response):
                onSuceed(response, target: target, isFromError: false)
            case let .failure(error):
                onFail(error, target: target)
            }
        }

        func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
            let request = response.request
            let url = request?.url?.absoluteString ?? "nil"
            let statusCode = response.statusCode
            var log = "------------------- 네트워크 통신 성공 -------------------"
            log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
            log.append("API: \(target)\n")
            response.response?.allHeaderFields.forEach {
                log.append("\($0): \($1)\n")
            }
            if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
                log.append("\(reString)\n")
            }
            log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------\n")

            switch logLevel {
            case .short:
                let log = "[🛜 Response] [\(statusCode)] [\(target)] \(url)"
                logger.log(level: .debug, "\(log)")
            case .detail:
                logger.log(level: .debug, "\(log)")
            }
        }

        func onFail(_ error: MoyaError, target: TargetType) {
            if let response = error.response {
                onSuceed(response, target: target, isFromError: true)
                return
            }
            var log = "네트워크 오류"
            log.append("<-- \(error.errorCode) \(target)\n")
            log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
            log.append("<-- END HTTP\n")

            logger.log("\(log)")
        }
    }

    extension CustomLoggingPlugin {
        /// Environment Variables 에서 로그 레벨을 가져오는 메소드
        /// Scheme의 Environment Variables 에 key : NETWORK_LOG_LEVEL, value : short 또는 detail
        private static func getLogLevelFromArguments() -> NetworkLogLevel? {
            guard let logLevelValue = ProcessInfo.processInfo.environment["NETWORK_LOG_LEVEL"] else { return nil }
            guard let networkLogLevel = NetworkLogLevel(rawValue: logLevelValue) else { return nil }
            return networkLogLevel
        }
    }

#endif
