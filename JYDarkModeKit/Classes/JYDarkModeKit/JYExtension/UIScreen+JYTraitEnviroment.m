//
//  UIScreen+JYTraitEnviroment.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import "UIScreen+JYTraitEnviroment.h"
#import "NSObject+JYTraitEnviroment.h"
@implementation UIScreen (JYTraitEnviroment)


- (JYTraitCollection *)jyTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [JYTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return JYTraitCollection.overrideTraitCollection;
}


- (void)jyTraitCollectionDidChange:( JYTraitCollection *)previousTraitCollection {
    
}

+ (void)swizzleUIScreenTraitCollectionDidChange API_AVAILABLE(ios(13.0)) {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    [self swizzleTraitCollectionDidChangeToJYTraitCollectionDidChangeWithBlock:^(id<UITraitEnvironment> object, UITraitCollection *previousTraitCollection) {
      if ([JYTraitCollection currentTraitCollection].userInterfaceStyle != JYInterfaceStyleUnspecified) {
        return;
      }
    }];
  });
}

@end
