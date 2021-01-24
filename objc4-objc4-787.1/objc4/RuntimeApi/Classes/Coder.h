//
//  Coder.h
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Coder : Person
+ (BOOL)addMethod;
+ (IMP)replaceMethod;
- (void)write;
@end

NS_ASSUME_NONNULL_END
