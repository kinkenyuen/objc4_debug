//
//  API.m
//  RuntimeApi
//
//  Created by jianqin_ruan on 2021/1/24.
//

#import "API.h"
#import "StructDefine.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "Person.h"
#import "Coder.h"

@implementation API

+ (void)_addLine {
    NSLog(@"************************************************************");
}

/// 类相关
+ (void)aboutClass {
    //获取类名
    const char *clsName = class_getName([Person class]);
    NSLog(@"kk | class_getName : %s",clsName);
    [self _addLine];
    
    //获取父类
    Class cls = class_getSuperclass([Person class]);
    NSLog(@"kk | Person class_getSuperclass : %@",cls);
    [self _addLine];
    
    //判断类对象是否为元类对象
    BOOL isMeta = class_isMetaClass([Person class]);
    NSLog(@"kk | Person class_isMetaClass : %d",isMeta);
    Class metaCls = objc_getMetaClass("Person");
    isMeta = class_isMetaClass(metaCls);
    NSLog(@"kk | Person class_isMetaClass again : %d",isMeta);
    [self _addLine];
    
    //类实例大小（内存布局/实例成员变量）字节对齐
    size_t size = class_getInstanceSize([Person class]);
    NSLog(@"kk | Person class_getInstanceSize : %zu",size);
    [self _addLine];
    
    //获取类的实例变量(struct objc_ivar *)
    //也会从父类往上找
    struct ivar_t *ivar = (struct ivar_t *)class_getInstanceVariable([Person class], "_name");
    if (ivar) {
        NSLog(@"kk | class_getInstanceVariable offset : %d",*ivar->offset);
        NSLog(@"kk | class_getInstanceVariable name : %s",ivar->name);
        NSLog(@"kk | class_getInstanceVariable type : %s",ivar->type);
        [self _addLine];
    }
    
    //获取元类的实例变量 ?
    //元类对象只有一个isa变量
    ivar = (struct ivar_t *)class_getClassVariable([Person class], "_name");
    if (ivar) {
        NSLog(@"kk | class_getClassVariable offset : %d",*ivar->offset);
        NSLog(@"kk | class_getClassVariable name : %s",ivar->name);
        NSLog(@"kk | class_getClassVariable type : %s",ivar->type);
        [self _addLine];
    }
    
    ivar = (struct ivar_t *)class_getClassVariable([Person class], "isa");
    if (ivar) {
        NSLog(@"kk | class_getClassVariable offset : %d",*ivar->offset);
        NSLog(@"kk | class_getClassVariable name : %s",ivar->name);
        NSLog(@"kk | class_getClassVariable type : %s",ivar->type);
        [self _addLine];
    }
    
    //动态添加类成员变量(已经存在编译好的类不能添加,只有这个类也是动态生成的时候有效)
    //Adding an instance variable to an existing class is not supported.
    //直接向一个已经存在的类添加实例变量是不可行的！
    BOOL addResult = class_addIvar([Person class], "_newName", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    NSLog(@"kk | class_addIvar : %d",addResult);
    //动态注册类
    Class workerCls = objc_allocateClassPair([NSObject class], "Worker", 0);
    addResult = class_addIvar(workerCls, "name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    NSLog(@"kk | dynamic class_addIvar : %d",addResult);
    objc_registerClassPair(workerCls);
    id worker = [workerCls alloc];
    [worker setValue:@"kinken" forKey:@"name"];
    NSLog(@"kk | worker name : %@",[worker valueForKey:@"name"]);
    [self _addLine];
    
    //获取类的实例变量列表
    unsigned int iCount = 0;
    struct ivar_t **ivars = (struct ivar_t **)class_copyIvarList([Person class], &iCount);
    for (unsigned int i = 0; i < iCount; i++) {
        NSLog(@"kk | class_copyIvarList offset : %d",*(((struct ivar_t *)ivars[i])->offset));
        NSLog(@"kk | class_copyIvarList name : %s",((struct ivar_t *)ivars[i])->name);
        NSLog(@"kk | class_copyIvarList type : %s",((struct ivar_t *)ivars[i])->type);
        [self _addLine];
    }
    
    //ivarLayout 通过特定的编码表示实例变量布局 (__strong) 0x2 表示有两个__strong修饰的实例变量
    const uint8_t *ivarLayout = class_getIvarLayout([Person class]);
    NSLog(@"kk | class_getIvarLayout : 0x%x",*ivarLayout);
    [self _addLine];
    
    //weakIvarLayout 通过特定的编码表示实例变量布局 (__weak) 0x21 表示有两个__strong修饰的实例变量,一个__weak修饰的实例变量
    ivarLayout = class_getWeakIvarLayout([Person class]);
    NSLog(@"kk | class_getWeakIvarLayout : 0x%x",*ivarLayout);
    [self _addLine];
    
    //一般不会主动调用setIvarLayout
    
    //获取类的一个属性
    //也会在继承链中找
    struct property_t *property = (struct property_t *)class_getProperty([Person class], "address");
    if (property) {
        NSLog(@"kk | class_getProperty name : %s",property->name);
        NSLog(@"kk | class_getProperty attributes : %s",property->attributes);
    }
    [self _addLine];
    
    //获取类的属性列表
    unsigned int pCount = 0;
    struct property_t **properties = (struct property_t **)class_copyPropertyList([Person class], &pCount);
    for (unsigned int i = 0; i < pCount; i++) {
        NSLog(@"kk | class_copyPropertyList name : %s",((struct property_t *)properties[i])->name);
    }
    [self _addLine];
    
    //动态向类添加方法
    BOOL isAdded = [Coder addMethod];
    NSLog(@"kk | class_addMethod ret : %d",isAdded);
    Coder *coder = [[Coder alloc] init];
    [coder write];
    [self _addLine];
    
    //动态获取实例方法
    struct method_t *method = (struct method_t *)class_getInstanceMethod([Coder class], @selector(write));
    if (method) {
        NSLog(@"kk | class_getInstanceMethod name : %s",(const char *)method->name());
        NSLog(@"kk | class_getInstanceMethod types : %s",method->types());
        NSLog(@"kk | class_getInstanceMethod imp : %p",method->imp(false));
        [self _addLine];
    }
    
    //动态获取类方法
    method = (struct method_t *)class_getClassMethod([Coder class], @selector(addMethod));
    if (method) {
        NSLog(@"kk | class_getClassMethod name : %s",(const char *)method->name());
        NSLog(@"kk | class_getClassMethod types : %s",method->types());
        NSLog(@"kk | class_getClassMethod imp : %p",method->imp(false));
        [self _addLine];
    }
    
    //获取实例方法列表
    unsigned int methodCount = 0;
    struct method_t **methods = (struct method_t **)class_copyMethodList([Coder class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        NSLog(@"kk | class_copyMethodList name : %s",(const char *)((struct method_t *)methods[i])->name());
        NSLog(@"kk | class_copyMethodList types : %s",(const char *)((struct method_t *)methods[i])->types());
        NSLog(@"kk | class_copyMethodList imp : %p",((struct method_t *)methods[i])->imp(false));
        [self _addLine];
    }
    
    //既然类对象是元类对象的实例，那么用上面的接口试试
    methodCount = 0;
    methods = (struct method_t **)class_copyMethodList(objc_getMetaClass("Coder"), &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        NSLog(@"kk | class_copyMethodList classMethod name : %s",(const char *)((struct method_t *)methods[i])->name());
        NSLog(@"kk | class_copyMethodList classMethod types : %s",(const char *)((struct method_t *)methods[i])->types());
        NSLog(@"kk | class_copyMethodList classMethod imp : %p",((struct method_t *)methods[i])->imp(false));
        [self _addLine];
    }
    
    /*修改方法IMP
     class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)
     1.如果方法不存在，则相当于addMethod,参数types会用到
     2.如果方法存在，则相当于替换掉IMP，types忽略
     */
    IMP imp = [Coder replaceMethod];
    if (imp) {
        [[[Coder alloc] init] write];
        [self _addLine];
        imp = nil;
    }
    
    //获取方法的IMP
    imp =  class_getMethodImplementation([Coder class], @selector(write));
    if (imp) {
        NSLog(@"kk | class_getMethodImplementation imp : %p",imp);
        [self _addLine];
    }
    
    //检查类是否响应SEL
    BOOL isRespond = class_respondsToSelector([Coder class], @selector(write));
    if (isRespond) {
        NSLog(@"kk | class_respondsToSelector ret : %d",isRespond);
        [self _addLine];
    }
    
    //看了一下源码，还有一部分API很类似，就不一一展开
}

+ (void)aboutLibraries {
    //获取加载的库
    unsigned int libraryCounts = 0;
    const char **names = objc_copyImageNames(&libraryCounts);
    for (unsigned int i = 0; i < libraryCounts; i++) {
        NSLog(@"kk | objc_copyImageNames : %s",names[i]);
        [self _addLine];
    }
    
    //获取某个类所在模块(库)
    const char *libName = class_getImageName([Coder class]);
    if (libName) {
        NSLog(@"kk | class_getImageName : %s",libName);
        [self _addLine];
    }
    
    //获取某个模块（库）里面的所有类
    unsigned int clsCount = 0;
    Dl_info info;
    dladdr(&_mh_execute_header, &info);
    const char **clses = objc_copyClassNamesForImage(info.dli_fname, &clsCount);
    for (unsigned int i = 0; i < clsCount; i++) {
        NSLog(@"kk | objc_copyClassNamesForImage : %s",clses[i]);
        [self _addLine];
    }
}

@end
