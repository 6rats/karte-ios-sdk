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

#import <Foundation/Foundation.h>

#if __has_include("KarteVariables-Swift.h")
#import "KarteVariables-Swift.h"
#else
#import <KarteVariables/KarteVariables-Swift.h>
#endif

@interface KRTVariablesLoader : NSObject

@end

@implementation KRTVariablesLoader

+ (void)load
{
    [KRTVariables _krt_load];
}

@end
