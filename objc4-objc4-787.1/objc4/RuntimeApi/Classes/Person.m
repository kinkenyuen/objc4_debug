//
//  Person.m
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import "Person.h"

@interface Person () {
    unsigned int _age;
}

@property (nonatomic, copy) NSString *phoneNumber;
@end

@implementation Person

- (void)write {
    NSLog(@"%s",__func__);
}

@end
