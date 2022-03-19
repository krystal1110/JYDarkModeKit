
//  UIView+JYDatkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import "UIView+JYDatkModeKit.h"
#import <objc/message.h>
#import "JYDynamicColor.h"
#import "UIColor+JYDarkModeKit.h"
#import "JYDynamicImageProxy.h"
#import "UIImageView+JYDarkModeKit.h"
@class  JYDynamicColorProxy;

@implementation UIView (JYDatkModeKit)


- (JYTraitCollection *)jyTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [JYTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return JYTraitCollection.overrideTraitCollection;
}

+ (void)jy_swizzleSetBackgroundColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(setBackgroundColor:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIView setBackgroundColor:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIView *self, UIColor *backgroundColor) {
      if ([backgroundColor isKindOfClass:[JYDynamicColor class]]) {
        self.jy_dynamicBackgroundColor = (JYDynamicColor *)backgroundColor;
      }
      else {
        self.jy_dynamicBackgroundColor = nil;
      }
      ((void (*)(UIView *, SEL, UIColor *))imp)(self, selector, backgroundColor);
    }), method_getTypeEncoding(method));
  });
}
 

- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection {
  if (@available(iOS 13.0, *)) {
    return;
  }
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view jyTraitCollectionDidChange:previousTraitCollection];
     }];
     
    [self setNeedsLayout];
    [self setNeedsDisplay];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_13_0
    [self jy_updateDynamicColors];
#endif
}

// MARK: - Legacy Support
- (void)jy_updateDynamicColors{
    JYDynamicColor * backgroundColor = [self jy_dynamicBackgroundColor];
    if (backgroundColor) {
        [self setBackgroundColor:backgroundColor];
    }
}

 
+ (void)jy_swizzleSetTintColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector =
      @selector(setTintColor:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIView setTintdColor:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIView *self, UIColor *tintColor) {
      if ([tintColor isKindOfClass:[JYDynamicColor class]]) {
        self.jy_dynamicTintColor = (JYDynamicColor *)tintColor;
      }
      else {
        self.jy_dynamicTintColor = nil;
      }
      ((void (*)(UIView *, SEL, UIColor *))imp)(self, selector, tintColor);
    }), method_getTypeEncoding(method));
  });
}


- (JYDynamicColor *)jy_dynamicBackgroundColor {
    return objc_getAssociatedObject(self, @selector(jy_dynamicBackgroundColor));
}

- (void)setJy_dynamicBackgroundColor:(JYDynamicColor *)jy_dynamicBackgroundColor {
    // 使用 @selector(jy_dynamicBackgroundColor) 作为key
    // value : jy_dynamicBackgroundColor
  objc_setAssociatedObject(self,
                           @selector(jy_dynamicBackgroundColor),
                           jy_dynamicBackgroundColor,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JYDynamicColor *)jy_dynamicTintColor {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setJy_dynamicTintColor:(JYDynamicColor *)jy_dynamicTintColor {
  objc_setAssociatedObject(self,
                           @selector(jy_dynamicTintColor),
                           jy_dynamicTintColor,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
