//
//  Dictionary+.swift
//  DebugSwift
//
//  Created by Matheus Gois on 15/12/23.
//  Copyright © 2023 apple. All rights reserved.
//

import Foundation

extension [String: Any] {
    func formattedString() -> String {
        var formattedString = ""
        for (key, value) in self {
            var modifyValue = value
            if let valueString = value as? String, let base64Data = Data.fromBase64(valueString) {
                modifyValue = String(data: base64Data, encoding: .utf8) ?? value
            }

            formattedString += "\(key): \(modifyValue)\n"
        }
        return formattedString
    }
}

extension [AnyHashable: Any] {
    func convertKeysToString() -> [String: Value] {
        var result: [String: Value] = [:]

        for (key, value) in self {
            if let keyString = key as? String {
                result[keyString] = value
            }
        }

        return result
    }
}

extension Dictionary {
    func asJsonStr() -> String? {
        var jsonStr: String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .sortedKeys)
            jsonStr = String(decoding: jsonData, as: UTF8.self)
        } catch {
            return nil
        }
        return jsonStr
    }
}

extension Data {
    static func fromBase64(_ encoded: String) -> Data? {
        var encoded = encoded
        let remainder = encoded.count % 4
        if remainder > 0 {
            encoded = encoded.padding(
                toLength: encoded.count + 4 - remainder,
                withPad: "=", startingAt: 0)
        }

        return Data(base64Encoded: encoded)
    }
}
