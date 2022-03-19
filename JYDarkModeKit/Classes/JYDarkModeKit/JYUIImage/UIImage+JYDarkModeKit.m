//
//  UIImage+JYDarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import "UIImage+JYDarkModeKit.h"
#import <objc/message.h>
static BOOL _useUIImageAsset = YES;

@implementation UIImage (JYDarkModeKit)

 


+ (BOOL)useUIImageAsset {
  return _useUIImageAsset;
}

+ (void)jy_swizzleIsEqual {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(isEqual:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIImage isEqual:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^BOOL(UIImage *self, UIImage *other) {
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

+ (UIImage *)jy_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage{
    if (@available(iOS 13, *)) {
      if ([UIImage useUIImageAsset]) {
        UIImageAsset *imageAsset = [[UIImageAsset alloc] init];

        // Always specify a displayScale otherwise a default of 1.0 is assigned
        [imageAsset registerImage:lightImage withTraitCollection:[UITraitCollection traitCollectionWithTraitsFromCollections:@[
          [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight],
          [UITraitCollection traitCollectionWithDisplayScale:lightImage.scale]
        ]]];

        [imageAsset registerImage:darkImage withTraitCollection:[UITraitCollection traitCollectionWithTraitsFromCollections:@[
          [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark],
          [UITraitCollection traitCollectionWithDisplayScale:darkImage.scale]
        ]]];

        return [imageAsset imageWithTraitCollection:JYTraitCollection.currentTraitCollection.uiTraitCollection];
      }
    }

    return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}



 





 


@end
