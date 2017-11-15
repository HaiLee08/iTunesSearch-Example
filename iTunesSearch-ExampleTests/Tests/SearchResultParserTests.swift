//
//  SearchResultParserTests.swift
//  iTunesSearch-ExampleTests
//
//  Created by William Boles on 13/11/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest

@testable import iTunesSearch_Example

class SearchResultParserTests: XCTestCase {
    
    var parser: SearchResultParser!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        parser = SearchResultParser()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_parsesValidResponse() {
        let json: [String: Any] = [
            "resultCount": 50,
            "results":[
                [
                    "wrapperType":"track",
                    "kind":"song",
                    "artistId":1147844711,
                    "collectionId":1140620351,
                    "trackId":1140620399,
                    "artistName":"Swift",
                    "collectionName":"Pull Up - Single",
                    "trackName":"Pull Up",
                    "collectionCensoredName":"Pull Up - Single",
                    "trackCensoredName":"Pull Up",
                    "artistViewUrl":"https://itunes.apple.com/us/artist/swift/1147844711?uo=4",
                    "collectionViewUrl":"https://itunes.apple.com/us/album/pull-up/1140620351?i=1140620399&uo=4",
                    "trackViewUrl":"https://itunes.apple.com/us/album/pull-up/1140620351?i=1140620399&uo=4",
                    "previewUrl":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview32/v4/7f/2f/27/7f2f27bf-1af7-4d46-a767-d989eadc2085/mzaf_7107069143306100047.plus.aac.p.m4a",
                    "artworkUrl30":"http://is3.mzstatic.com/image/thumb/Music42/v4/c6/56/78/c656786e-b41c-d3aa-1781-51fa8ab0d1d0/source/30x30bb.jpg",
                    "artworkUrl60":"http://is3.mzstatic.com/image/thumb/Music42/v4/c6/56/78/c656786e-b41c-d3aa-1781-51fa8ab0d1d0/source/60x60bb.jpg",
                    "artworkUrl100":"http://is3.mzstatic.com/image/thumb/Music42/v4/c6/56/78/c656786e-b41c-d3aa-1781-51fa8ab0d1d0/source/100x100bb.jpg",
                    "collectionPrice":1.29,
                    "trackPrice":1.29,
                    "releaseDate":"2016-06-13T07:00:00Z",
                    "collectionExplicitness":"explicit",
                    "trackExplicitness":"explicit",
                    "discCount":1,
                    "discNumber":1,
                    "trackCount":1,
                    "trackNumber":1,
                    "trackTimeMillis":210968,
                    "country":"USA",
                    "currency":"USD",
                    "primaryGenreName":"Hip-Hop/Rap",
                    "contentAdvisoryRating":"Explicit",
                    "isStreamable":true
                ],
                [
                    "wrapperType":"track",
                    "kind":"song",
                    "artistId":159260351,
                    "collectionId":1274999981,
                    "trackId":1274999999,
                    "artistName":"Taylor Swift",
                    "collectionName":"reputation",
                    "trackName":"Look What You Made Me Do",
                    "collectionCensoredName":"reputation",
                    "trackCensoredName":"Look What You Made Me Do",
                    "artistViewUrl":"https://itunes.apple.com/us/artist/taylor-swift/159260351?uo=4",
                    "collectionViewUrl":"https://itunes.apple.com/us/album/look-what-you-made-me-do/1274999981?i=1274999999&uo=4",
                    "trackViewUrl":"https://itunes.apple.com/us/album/look-what-you-made-me-do/1274999981?i=1274999999&uo=4",
                    "previewUrl":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview128/v4/35/e6/81/35e68178-723f-9f06-6c92-04f81e2acfb9/mzaf_4847328976572813745.plus.aac.p.m4a",
                    "artworkUrl30":"http://is2.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/30x30bb.jpg",
                    "artworkUrl60":"http://is2.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/60x60bb.jpg",
                    "artworkUrl100":"http://is2.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/100x100bb.jpg",
                    "collectionPrice":13.99,
                    "trackPrice":1.29,
                    "releaseDate":"2017-08-25T07:00:00Z",
                    "collectionExplicitness":"notExplicit",
                    "trackExplicitness":"notExplicit",
                    "discCount":1,
                    "discNumber":1,
                    "trackCount":15,
                    "trackNumber":6,
                    "trackTimeMillis":211859,
                    "country":"USA",
                    "currency":"USD",
                    "primaryGenreName":"Pop",
                    "isStreamable":false
                ]
            ]
        ]
        
        let searchResults = parser.parseResponse(json)
        
        XCTAssertEqual(searchResults.count, 2)
        
        let secondSearchResult = searchResults[1]
        
        XCTAssertEqual(secondSearchResult.artistName, "Taylor Swift")
        XCTAssertEqual(secondSearchResult.trackName, "Look What You Made Me Do")
        XCTAssertEqual(secondSearchResult.artworkURL, URL(string: "http://is2.mzstatic.com/image/thumb/Music128/v4/bc/84/77/bc847733-8fcd-1040-8ddb-4271601f4151/source/100x100bb.jpg"))
        XCTAssertEqual(secondSearchResult.trackDetailsURL, URL(string: "https://itunes.apple.com/us/album/look-what-you-made-me-do/1274999981?i=1274999999&uo=4"))
        XCTAssertEqual(secondSearchResult.price, 1.29)
        XCTAssertEqual(secondSearchResult.currency, "USD")
    }
    
    //Additional tests covering unhappy paths
}
