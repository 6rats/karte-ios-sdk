//
//  Copyright 2020 PLAID, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Quick
import Nimble
import KarteUtilities
@testable import KarteCore

class EventFilterSpec: QuickSpec {
    
    override func spec() {
        describe("a empty event name filter rule") {
            var filter: EventFilter!
            
            beforeEach {
                filter = EventFilter.Builder().add(EmptyEventNameFilterRule()).build()
            }
            
            context("when event name is empty") {
                it("throw error") {
                    let event = Event(eventName: EventName(""))
                    expect(expression: {
                        try filter.filter(event)
                    }).to(throwError())
                }
            }
            
            context("when event name is nativeAppOpen") {
                it("not throw error") {
                    expect(expression: {
                        try filter.filter(Event(.open))
                    }).toNot(throwError())
                }
            }
        }
        
        describe("a non ascii event name filter rule") {
            var filter: EventFilter!
            
            beforeEach {
                filter = EventFilter.Builder().add(NonAsciiEventNameFilterRule()).build()
            }
            
            context("when event name contains non ascii character") {
                it("not throw error") {
                    let event = Event(eventName: EventName("イベント"))
                    expect(expression: {
                        try filter.filter(event)
                    }).toNot(throwError())
                }
            }
            
            context("when event name not contains non ascii character") {
                it("not throw error") {
                    let event = Event(eventName: EventName("event"))
                    expect(expression: {
                        try filter.filter(event)
                    }).toNot(throwError())
                }
            }
        }
        
        describe("a unretryable event filter rule") {
            var filter: EventFilter!
            
            beforeEach {
                filter = EventFilter.Builder().add(UnretryableEventFilterRule()).build()
            }
            
            context("when unretryable event passed") {
                context("when online") {
                    it("not throw error") {
                        let event = Event(eventName: EventName("_fetch_variables"))
                        expect(expression: {
                            try filter.filter(event)
                        }).toNot(throwError())
                    }
                }
                context("when offline") {
                    beforeEach {
                        Resolver.root = Resolver.submock
                        Resolver.root.register(Bool.self, name: "isReachable") {
                            false
                        }
                    }
                    afterEach {
                        Resolver.root = Resolver.mock
                    }
                    it("throw error") {
                        let event = Event(eventName: EventName("_fetch_variables"))
                        expect(expression: {
                            try filter.filter(event)
                        }).to(throwError())
                    }
                }
            }
            
            context("when retryable event passed") {
                context("when online") {
                    it("not throw error") {
                        let event = Event(eventName: EventName("event"))
                        expect(expression: {
                            try filter.filter(event)
                        }).toNot(throwError())
                    }
                }
                context("when offline") {
                    beforeEach {
                        Resolver.root = Resolver.submock
                        Resolver.root.register(Bool.self, name: "isReachable") {
                            false
                        }
                    }
                    afterEach {
                        Resolver.root = Resolver.mock
                    }
                    it("not throw error") {
                        let event = Event(eventName: EventName("event"))
                        expect(expression: {
                            try filter.filter(event)
                        }).toNot(throwError())
                    }
                }
            }
        }
        
        describe("a default event filter rule") {
            var filter: EventFilter!
            
            beforeEach {
                filter = EventFilter.Builder().add(InitializationEventFilterRule()).build()
            }
            
            context("when event is initialization event") {
                it("throw error") {
                    expect(expression: {
                        try filter.filter(Event(.open))
                    }).to(throwError())
                }
            }
            
            context("when event is not initialization event") {
                it("not throw error") {
                    let event = Event(eventName: EventName("event"))
                    expect(expression: {
                        try filter.filter(event)
                    }).toNot(throwError())
                }
            }
        }
    }
}
