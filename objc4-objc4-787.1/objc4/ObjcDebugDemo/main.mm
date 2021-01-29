//
//  main.m
//  ObjcDebugDemo
//
//  Created by jianqin_ruan on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Student.h"

//class Person{
//public:
//    Person(){
//        printf("Person::Person()\n");
//    }
//
//    ~Person(){
//        printf("Person::~Person()\n");
//    }
//};
//
////静态初始化
//const NSString *key = @"key";
//
///*
// 在main函数之前执行的代码
// */
//
////动态初始化(需要执行C++的构造函数)
//Person kinken;
//
////全局构造函数
//__attribute__((constructor)) void myentry(){
//    NSLog(@"constructor");
//}
//
////变量初始化需要执行函数
//bool initBar(){
//    int i = 0;
//    ++i;
//    return i == 1;
//}
//
//static bool globalBar = initBar();
//bool globalBar2 = initBar();
//
////构造Objective-C类
//static NSDictionary * dictObject = @{@"one":@"1"};
//NSDictionary * dictObject2 = @{@"one":@"1", @"two":@"2"};
//
////struct
//CGRect globalRect = CGRectZero;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        NSLog(@"kk | hash : %lu",(unsigned long)hash);
//        NSLog(@"kk | superclass : %@",p.superclass);
//        NSLog(@"kk | p Self : %@",[p self]);
//
//        BOOL flag = [p isKindOfClass:[Person class]];
//        NSLog(@"kk | isKindOfClass : %d",flag);
//
//        NSLog(@"kk | conformsToProtocol : %d",[p conformsToProtocol:@protocol(NSFileManagerDelegate)]);
//        NSLog(@"kk | responseToSelector : %d",[p respondsToSelector:@selector(play)]);
        
//        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//        BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
//        BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
//        NSLog(@"%d %d %d %d", res1, res2, res3, res4);
        
        Person *p = [Person alloc];
        NSLog(@"kk | p : %@",p);
    }
    return 0;
}
