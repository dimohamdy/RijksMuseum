//
//  ProxyLogger.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 12/03/2023.
//

import Foundation
import os.log

class ProxyLogger: LoggerProtocol {

    let logger: Logger

    init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    func log(_ message: String, level: LogLevel) {

        // Map the LogLevel to the corresponding OSLogType
        let logType: OSLogType
        switch level {
        case .debug:
            logType = .debug
        case .info:
            logType = .info
        case .warning:
            logType = .default
        case .error:
            logType = .error
        }

        #if DEBUG
            logger.log(level: logType, "ProxyLogger: \(message)")
        #endif
    }
}
