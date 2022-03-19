//
//  UIImageView+JYDarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import "UIImageView+JYDarkModeKit.h"
#import <objc/message.h>
#import "UIImage+JYDarkModeKit.h"

static const void *JYKEY = &JYKEY;

@implementation UIImageView (JYDarkModeKit)

 

+ (void)jy_swizzleSetImage {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      
    SEL selector = @selector(setImage:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIView setImage:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIImageView *self, UIImage *image) {
      if (object_getClass(image) == JYDynamicImageProxy.class) {
        self.jy_dynamicImage = (JYDynamicImageProxy *)image;
      }
      else {
        self.jy_dynamicImage = nil;
      }
      ((void (*)(UIImageView *, SEL, UIImage *))imp)(self, selector, image);
    }), method_getTypeEncoding(method));
  });
}

- (JYDynamicImageProxy *)jy_dynamicImage{
    return objc_getAssociatedObject(self, JYKEY);
}

- (void)setJy_dynamicImage:(JYDynamicImageProxy *)jy_dynamicImage {
  objc_setAssociatedObject(self,
                           JYKEY,
                           jy_dynamicImage,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)jyTraitCollectionDidChange:(JYTraitCollection *)traitCollection {
    if (@available(iOS 13, *)) {
        return;;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    // iOS13以上 会失效
    JYDynamicImageProxy * imgaeProxy =  self.jy_dynamicImage;
    if (imgaeProxy) {
    [self setImage:(UIImage*)imgaeProxy];
    }
}


@end
