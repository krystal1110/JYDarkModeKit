//
//  UIColor+JYDarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import "UIColor+JYDarkModeKit.h"
#import "JYDynamicColor.h"
@implementation UIColor (JYDarkModeKit)

+ (UIColor *)jy_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  if (@available(iOS 13.0, *)) {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
      return traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? darkColor : lightColor;
    }];
  }
  return [JYDynamicColor colorWithLightColor:lightColor darkColor:darkColor];
}


+ (UIColor *)jy_colorWithDynamicProvider:(UIColor *(^)(JYTraitCollection *))dynamicProvider {
  if (@available(iOS 13.0, *)) {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
      return dynamicProvider([JYTraitCollection traitCollectionWithUITraitCollection:traitCollection]);
    }];
  }
  return [JYDynamicColor colorWithDynamicProvider:dynamicProvider];
}

- (UIColor *)jy_resolvedColorWithTraitCollection:(JYTraitCollection *)traitCollection {
  if (@available(iOS 13.0, *)) {
    return [self resolvedColorWithTraitCollection:traitCollection.uiTraitCollection];
  }
  return self;
}



@end
