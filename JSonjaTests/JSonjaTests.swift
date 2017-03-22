//
//  JSonjaTests.swift
//  JSonjaTests
//
//  Created by Tai Shimizu on 3/21/17.
//  Copyright © 2017 Tai Shimizu. All rights reserved.
//

import XCTest
@testable import JSonja

class JSonjaTests: XCTestCase {
    let testJson: [String: Any] = ["TeamName": "JSonja Rollergirls",
                                
                                   "Location": ["City": "Laupahoehoe",
                                                "State": "HI",
                                                "Zip": 96764],
                                   
                                   "FoundingYear": 2017,
                                   
                                   "TrackType": "Flat",

                                   "Players": [["Name": "Janie Fury",
                                                "Number": 64,
                                                "Positions": ["Jammer", "Blocker", "Pivot"]],
                                               ["Name": "Watership Throwdown",
                                                "Number": 967,
                                                "Positions": ["Blocker", "Pivot"]],
                                               ["Name": "Amber Alert",
                                                "Number": 14],
                                               ["Name": "Isabella",
                                                "Number": 2011]
                                             ]
        ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        guard let sonja = JsonItem(dict: testJson) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(sonja["TeamName"]!, "JSonja Rollergirls")
        
        let nonExistent: String? = sonja["badKey"]
        XCTAssertNil(nonExistent)
        
        let city: String? = sonja["Location"]?["City"]
        XCTAssertEqual(city!, "Laupahoehoe")
        
        let firstPlayerNumber: Int? = sonja["Players"]?[0]["Number"]
        XCTAssertEqual(firstPlayerNumber!, 64)

    }
    
    func testClassConstruction() {
        guard let team: DerbyTeam = DerbyTeam(item: JsonItem(dict: testJson)) else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(team.teamName, "JSonja Rollergirls")
        XCTAssertEqual(team.location.city, "Laupahoehoe")
        XCTAssertEqual(team.location.zip, 96764)
        XCTAssertEqual(team.players?[0].name, "Janie Fury")
        XCTAssertEqual(team.players?[0].number, 64)
    }
    
}

struct DerbyTeam: JSonjaConstructed {
    let teamName: String
    let location: Location
    let foundingYear: Int?
    let players: [Player]?
    
    init?(item: JsonItem?){
        guard let item = item else { return nil }
        do {
            teamName = try item["TeamName"]~!
            location = try item["Location"]~!
        } catch _ {
            return nil
        }
        foundingYear = item["FoundingYear"]
        players = item["Players"]~
    }
}

struct Location: JSonjaConstructed {
    let address: String?
    let city: String
    let state: String
    let zip: Int
    
    init?(item: JsonItem?){
        guard
            let item = item,
            let city: String = item["City"],
            let state: String = item["State"],
            let zip: Int = item["Zip"]
            else { return nil }
        
        self.city = city
        self.state = state
        self.zip = zip
        address = item["Address"]
    }
}

struct Player: JSonjaConstructed {
    let name: String
    let number: Int
    let positions: [String]?
    init?(item: JsonItem?){
        guard
            let item = item,
            let name: String = item["Name"],
            let number: Int = item["Number"]
            else { return nil }
        self.name = name
        self.number = number
        positions = item["Positions"]
    }
}

