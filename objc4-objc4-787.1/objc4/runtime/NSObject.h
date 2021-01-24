/*	NSObject.h
	Copyright (c) 1994-2012, Apple Inc. All rights reserved.
*/

#ifndef _OBJC_NSOBJECT_H_
#define _OBJC_NSOBJECT_H_

#if __OBJC__

#include <objc/objc.h>
#include <objc/NSObjCRuntime.h>

@class NSString, NSMethodSignature, NSInvocation;

@protocol NSObject

//内部用 == 判断
- (BOOL)isEqual:(id)object;

//直接返回对象的内存地址
@property (readonly) NSUInteger hash;

//返回当前实例对象所属类的父类
@property (readonly) Class superclass;

//返回当前实例对象所属类
- (Class)class OBJC_SWIFT_UNAVAILABLE("use 'type(of: anObject)' instead");


- (instancetype)self;

//依旧是调用objc_msgSend + 参数
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

- (BOOL)isProxy;

//通过superclass指针遍历继承链
- (BOOL)isKindOfClass:(Class)aClass;

//判断某个实例是不是该类的实例，不走继承链
- (BOOL)isMemberOfClass:(Class)aClass;

//某个类是否遵循协议
//读取类结构体 cls->data()->protocols() 检查是否有目标协议或者在协议的继承链找
- (BOOL)conformsToProtocol:(Protocol *)aProtocol;

//|class_respondsToSelector_inst
//  |lookUpImpOrNil
//      |lookUpImpOrForward
//          |getMethodNoSuper_nolock
//根据getMethodNoSuper_nolock(cls,sel）查找是否有对应sel的method，有的话返回IMP(YES)
//没有的话尝试一次方法解析 resolveMethod_locked
- (BOOL)respondsToSelector:(SEL)aSelector;

- (instancetype)retain OBJC_ARC_UNAVAILABLE;
- (oneway void)release OBJC_ARC_UNAVAILABLE;
- (instancetype)autorelease OBJC_ARC_UNAVAILABLE;
- (NSUInteger)retainCount OBJC_ARC_UNAVAILABLE;

- (struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;

@property (readonly, copy) NSString *description;
@optional
@property (readonly, copy) NSString *debugDescription;

@end


OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0)
OBJC_ROOT_CLASS
OBJC_EXPORT
@interface NSObject <NSObject> {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
    Class isa  OBJC_ISA_AVAILABILITY;
#pragma clang diagnostic pop
}

+ (void)load;

+ (void)initialize;
- (instancetype)init
#if NS_ENFORCE_NSOBJECT_DESIGNATED_INITIALIZER
    NS_DESIGNATED_INITIALIZER
#endif
    ;

+ (instancetype)new OBJC_SWIFT_UNAVAILABLE("use object initializers instead");
+ (instancetype)allocWithZone:(struct _NSZone *)zone OBJC_SWIFT_UNAVAILABLE("use object initializers instead");

//内部主要做了两件事
//1.计算对象所需内存大小，字节对齐然后分配内存空间
//2.初始化对象的isa
+ (instancetype)alloc OBJC_SWIFT_UNAVAILABLE("use object initializers instead");
- (void)dealloc OBJC_SWIFT_UNAVAILABLE("use 'deinit' to define a de-initializer");

- (void)finalize OBJC_DEPRECATED("Objective-C garbage collection is no longer supported");

- (id)copy;
- (id)mutableCopy;

+ (id)copyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;
+ (id)mutableCopyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;

//实现跟- (BOOL)respondsToSelector:(SEL)aSelector;一样
+ (BOOL)instancesRespondToSelector:(SEL)aSelector;

//实现跟- (BOOL)conformsToProtocol:(Protocol *)aProtocol;一样
+ (BOOL)conformsToProtocol:(Protocol *)protocol;

// | object_getMethodImplementation
//      | class_getMethodImplementation
//          | lookUpImpOrNil找不到IMP就返回_objc_msgForward
- (IMP)methodForSelector:(SEL)aSelector;

//| class_getMethodImplementation
//   | lookUpImpOrNil找不到IMP就返回_objc_msgForward
+ (IMP)instanceMethodForSelector:(SEL)aSelector;

//对象不能响应消息或者不能转发消息时，runtime调用该方法抛出一个异常
- (void)doesNotRecognizeSelector:(SEL)aSelector;

//消息转发第二阶段
- (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
//消息转发第三阶段
- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("");
//消息转发第三阶段，必须先实现该方法构造本次消息调用对应的NSMethodSignature
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");

- (BOOL)allowsWeakReference UNAVAILABLE_ATTRIBUTE;
- (BOOL)retainWeakReference UNAVAILABLE_ATTRIBUTE;

+ (BOOL)isSubclassOfClass:(Class)aClass;

+ (BOOL)resolveClassMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
+ (BOOL)resolveInstanceMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);

+ (NSUInteger)hash;
+ (Class)superclass;
+ (Class)class OBJC_SWIFT_UNAVAILABLE("use 'aClass.self' instead");
+ (NSString *)description;
+ (NSString *)debugDescription;

@end

#endif

#endif
