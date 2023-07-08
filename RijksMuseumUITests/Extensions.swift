//
//  String.swift
//  TestMockServer
//

import Foundation

// swiftlint:disable all
public extension String {
    var json: [String: Any] {
        try! JSONSerialization.jsonObject(with: Data(self.utf8),
                                          options: .mutableContainers) as! [String: Any]
    }
}

public extension Dictionary {
    func toString(prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: self, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
}
// swiftlint:enable all
