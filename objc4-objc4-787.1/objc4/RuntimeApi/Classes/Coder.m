//
//  Coder.m
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import "Coder.h"
#import <objc/runtime.h>

@implementation Coder

- (void)write {
    NSLog(@"kk | %s",__func__);
}

void writeIMP(id self, SEL _cmd) {
    NSLog(@"kk | %s",__func__);
}

void newWriteIMP(id self, SEL _cmd) {
    NSLog(@"kk | %s",__func__);
}

+ (BOOL)addMethod {
    return class_addMethod([self class], @selector(write), (IMP) writeIMP, "v@:");
}

+ (IMP)replaceMethod {
    return class_replaceMethod([Coder class], @selector(write), (IMP)newWriteIMP, "v@:");
}

@end
