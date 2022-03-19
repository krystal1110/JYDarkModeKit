//
//  UIViewController+DarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import "UIViewController+JYDarkModeKit.h"
#import "UIView+JYDatkModeKit.h"
@implementation UIViewController (JYDarkModeKit)

- (JYTraitCollection *)jyTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [JYTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return JYTraitCollection.overrideTraitCollection;
}


- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection {
  if (@available(iOS 13, *))
    return;

  [self setNeedsStatusBarAppearanceUpdate];
  [[self presentedViewController] jyTraitCollectionDidChange:previousTraitCollection];
  [[self childViewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull child, NSUInteger idx, BOOL * _Nonnull stop) {
    [child jyTraitCollectionDidChange:previousTraitCollection];
  }]; 
    // 已经加载的视图 通知当前view开始修改
    if ([self isViewLoaded]){
        [[self view]jyTraitCollectionDidChange:previousTraitCollection];
    }
}

@end
