//
//  main.m
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "API.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [API aboutClass];
        [API aboutLibraries];
    }
    return 0;
}
