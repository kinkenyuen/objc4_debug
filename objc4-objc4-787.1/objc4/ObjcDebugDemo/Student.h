//
//  Student.h
//  ObjcDebugDemo
//
//  Created by jianqin_ruan on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject {
    NSInteger no;
    NSString *name;
    NSString *address;
}
- (void)talk;
@end

NS_ASSUME_NONNULL_END
