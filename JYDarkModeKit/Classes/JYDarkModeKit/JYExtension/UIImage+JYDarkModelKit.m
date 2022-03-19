//
//  UIImage+JYDarkModelKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/19.
//

#import "UIImage+JYDarkModelKit.h"
#import <objc/message.h>
#import "JYDynamicImageProxy.h"

static BOOL _useUIImageAsset = YES;

@implementation UIImage (JYDarkModelKit)

+ (BOOL)useUIImageAsset {
  return _useUIImageAsset;
}

+ (void)dm_swizzleIsEqual {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(isEqual:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIImage isEqual:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^BOOL(UIImage *self, UIImage *other) {
      /// On iOS 13, UIImage `isEqual:` somehow changes internally and doesn't work for `NSProxy`,
      /// here we forward the message to internal images manually
      UIImage *realSelf = self;
      UIImage *realOther = other;
      if (object_getClass(self) == JYDynamicImageProxy.class) {
        realSelf = ((JYDynamicImageProxy *)self).resolvedImage;
      }
      if (object_getClass(other) == JYDynamicImageProxy.class) {
        realOther = ((JYDynamicImageProxy *)other).resolvedImage;
      }
      return ((BOOL(*)(UIImage *, SEL, UIImage *))imp)(realSelf, selector, realOther);
    }), method_getTypeEncoding(method));

    _useUIImageAsset = NO;
  });
}

@end
