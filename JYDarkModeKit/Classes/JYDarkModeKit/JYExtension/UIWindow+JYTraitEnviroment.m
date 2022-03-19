//
//  UIWindow+JYTraitEnviroment.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import "UIWindow+JYTraitEnviroment.h"
#import "UIViewController+JYDarkModeKit.h"

@implementation UIWindow (JYTraitEnviroment)

 
- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection {

  if (@available(iOS 13, *)) {
    if (previousTraitCollection.userInterfaceStyle != self.jyTraitCollection.userInterfaceStyle && _windowThemeChangeHandler)
      _windowThemeChangeHandler(self);
  } else {
      [[self rootViewController]jyTraitCollectionDidChange:previousTraitCollection];
  }
}







@end
