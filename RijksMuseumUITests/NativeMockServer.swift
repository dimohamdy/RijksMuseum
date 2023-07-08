//
//  NativeMockServer.swift
//  NativeMockServer
//

import Foundation
import Swifter

final class NativeMockServer {

    private var server = HttpServer()
    private var port: UInt16 = 4561
    private var collectionResponse: HttpResponse?
    private var artObjectDetailsResponse: HttpResponse?

    func start() {
        configure()
        try! server.start(port) // swiftlint:disable:this force_try
        print("Server status: \(server.state). Port: \(port)")
    }

    func stop() {
        server.stop()
    }

    func update(collectionResponse: HttpResponse) {
        self.collectionResponse = collectionResponse
    }

    func update(artObjectDetailsResponse: HttpResponse) {
        self.artObjectDetailsResponse = artObjectDetailsResponse
    }

    private func configure() {
        server["api/en/collection?key=*&imgonly=true&type=*&ps=*&p=*"] = { [self] _ in
            let response = readData(fromFile: "data_collection")
            return collectionResponse ?? .ok(.json(response))
        }

        server["api/en/collection/*?key=*"] = { [self] _ in
            let response = readData(fromFile: "ArtObjectDetailsResult")
            return artObjectDetailsResponse ?? .ok(.json(response))
        }
    }

    func readData(fromFile name: String, ext: String = "json") -> [String: Any] {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: name, withExtension: ext)!
        let data = try! Data(contentsOf: url) // swiftlint:disable:this force_try
        return String(bytes: data, encoding: .utf8)!.json
    }
}
