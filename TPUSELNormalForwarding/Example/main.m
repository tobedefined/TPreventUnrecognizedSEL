//
//  main.m
//  Example
//
//  Created by TBD on 2017/11/24.
//  Copyright © 2017年 邵伟男. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TPUSELFastForwarding/TPUSELFastForwarding.h>

@interface TestNormalForwardingOBJ: NSObject
@end

@implementation TestNormalForwardingOBJ
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, Begin Test Fast Forwarding");
        [NSObject setHandleUnrecognizedSELErrorBlock:^(Class  _Nonnull __unsafe_unretained cls, SEL  _Nonnull selector, UnrecognizedMethodType methodType) {
            NSString *typeStr = @"Lost Class    Method";
            if (methodType == UnrecognizedMethodTypeInstanceMethod) {
                typeStr = @"Lost Instance Method";
            }
            NSLog(@"CLASS: %@, %@ ==> %@", NSStringFromClass(cls), typeStr, NSStringFromSelector(selector));
        }];
        
        [[[TestNormalForwardingOBJ alloc] init] performSelector:@selector(iOS:losted:instance:method:inVC:)];
        [TestNormalForwardingOBJ performSelector:@selector(iOS:losted:class:method:inVCClass:)];
        
        NSLog(@"Test Normal Forwarding Success");
    }
    return 0;
}

