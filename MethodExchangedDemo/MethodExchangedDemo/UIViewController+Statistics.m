//
//  UIViewController+Statistics.m
//  MethodExchangedDemo
//
//  Created by ztp on 2018/2/6.
//  Copyright © 2018年 ztp. All rights reserved.
//

#import "UIViewController+Statistics.h"
#import <objc/message.h>


@implementation UIViewController (Statistics)

+ (void)load
{
    [self ZTPMethodSwizzing:self methodOld:@selector(viewDidAppear:) methodNew:@selector(ZTP_WillDidAppear:)];
    
}

+ (void)ZTPMethodSwizzing:(Class)className methodOld:(SEL)oldMethod methodNew:(SEL)newMethod
{
    //1:先拿到这两个方法
    Method originalMethod = class_getInstanceMethod(className, oldMethod);
    Method swizzledMethod = class_getInstanceMethod(className, newMethod);

    
    /**2:若UIViewController类没有该方法,那么它会去UIViewController的父类去寻找,为了避免不必要的麻烦,我们先进行一次添加
    */
    BOOL AddMethod = class_addMethod(className, oldMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    //3: 如果原来类没有这个方法,可以成功添加,如果原来类里面有这个方法,那么将会添加失败
    if (AddMethod) {
        class_replaceMethod(className, oldMethod, class_getMethodImplementation(className, newMethod), method_getTypeEncoding(swizzledMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ZTP_WillDidAppear:(BOOL)isAnimation
{
    [self ZTP_WillDidAppear:isAnimation];
    NSString * namestr = NSStringFromClass([self class]);
    
    NSLog(@"do something for statics in class %@",namestr);
    //如果项目中集成了友盟统计,那么就可以在此处实现
    
//    [MobClick beginLogPageView:namestr];
}

@end
