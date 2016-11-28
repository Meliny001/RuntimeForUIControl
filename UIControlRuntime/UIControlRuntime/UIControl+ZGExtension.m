//
//  UIControl+ZGExtension.m
//  UIControlRuntime
//
//  Created by HYG_IOS on 2016/11/28.
//  Copyright © 2016年 magic. All rights reserved.
//

#import "UIControl+ZGExtension.h"
#import <objc/runtime.h>

@interface UIControl ()
@property (nonatomic,assign) NSTimeInterval eventLastTime;/**<上一次点击时间*/
@end

static char eventTimeIntervalKey;
static char eventLastTimeKey;

@implementation UIControl (ZGExtension)

+(void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method swizzlingMethod = class_getInstanceMethod([self class], @selector(zgSendAction:to:forEvent:));
    BOOL addMethod = class_addMethod([self class], @selector(sendAction:to:forEvent:), method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    if (addMethod)
    {
        class_replaceMethod([self class], @selector(zgSendAction:to:forEvent:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else
    {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}
- (void)zgSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // 设置默认值(no UISwitch)
    if (self.eventTimeInterval <= 0) {
        self.eventTimeInterval = 1.5f;
    }
    
    BOOL canAction = (NSDate.date.timeIntervalSince1970 - self.eventLastTime >= self.eventTimeInterval);
    
    // 更新last
    if (self.eventTimeInterval >0) {
        self.eventLastTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 大于时间间隔时执行系统
    if (canAction){
        [self zgSendAction:action to:target forEvent:event];
    }
}

#pragma mark - setter/getter
- (NSTimeInterval)eventTimeInterval
{
    return [objc_getAssociatedObject(self, &eventTimeIntervalKey) doubleValue];
}
- (void)setEventTimeInterval:(NSTimeInterval)eventTimeInterval
{
    objc_setAssociatedObject(self, &eventTimeIntervalKey, @(eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)eventLastTime
{
    return [objc_getAssociatedObject(self, &eventLastTimeKey) doubleValue];
}
- (void)setEventLastTime:(NSTimeInterval)eventLastTime
{
    objc_setAssociatedObject(self, &eventLastTimeKey, @(eventLastTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
