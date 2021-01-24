//
//  Person.h
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject {
    NSString *_name;
    NSString *_secondName;
    __weak id delegate;
}
@property (nonatomic, copy) NSString *address;

- (void)write;
@end

NS_ASSUME_NONNULL_END
