//
//  UIKit+BaseExtension.m
//  星空浩818
//
//  Created by 星空浩818 on 14/10/17.
//  Copyright (c) 2014年 星空浩818. All rights reserved.
//

#import "UIKit+BaseExtension.h"
#import "AppDelegate.h"

@implementation UIView (baseExtension)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGRect)screenFrame
{
    return [self convertRect:self.bounds toView:nil];
}

- (CGFloat)screenX
{
    return self.screenFrame.origin.x;
}

- (CGFloat)screenY
{
    return self.screenFrame.origin.y;
}

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end

@implementation UIColor (baseExtension)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    return [self colorWithR:r G:g B:b A:1];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    return [self colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}

@end

@implementation UIImage (baseExtension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIDevice (baseExtensions)

+ (IPhoneType)iphoneType
{
    
    if (SCREEN_HEIGHT*[UIScreen mainScreen].scale >= 667*3) {
        return IPhone6P;
    }
    
    if (SCREEN_HEIGHT*[UIScreen mainScreen].scale >= 667*2) {
        return IPhone6;
    }
    
    if (SCREEN_HEIGHT == 568) {
        return IPhone5;
    }
    
    if (SCREEN_HEIGHT == 480) {
        return IPhone4;
    }
    
    return IPhone5;
}

@end

@implementation UITextField (baseExtension)

- (NSRange)selectedRange
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];

    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange) range
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end

@implementation UIApplication (baseExtension)

+ (UIWindow *)sharedAppWindow
{
    return [self sharedApp].window;
}

+ (AppDelegate*)sharedApp
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end

@implementation UINavigationController (baseExtension)

+ (UINavigationController *)currentNavigationController
{
    UINavigationController *currentNav = nil;
    id obj = [UIApplication sharedAppWindow].rootViewController;
    if ([obj isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = obj;
        currentNav = (UINavigationController*)tab.selectedViewController;
    }
    
    if ([obj isKindOfClass:[UINavigationController class]]) {
        currentNav = obj;
    }

    return currentNav;
}

@end
