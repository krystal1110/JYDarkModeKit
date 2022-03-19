//
//  JYTraitCollection.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import "JYTraitCollection.h"
#import "UIView+JYDatkModeKit.h"
#import "UIViewController+JYDarkModeKit.h"
#import "NSObject+JYTraitEnviroment.h"
#import "UIImageView+JYDarkModeKit.h"
#import "NSObject+JYTraitEnviroment.h"
#import "UIScreen+JYTraitEnviroment.h"
#import "UIImage+JYDarkModelKit.h"

@class JYTraitEnvironment;

static JYTraitCollection *_overrideTraitCollection = nil;
static BOOL _isObservingNewWindowAddNotification = NO;
 
//用户界面样式变更处理程序
static void (^_userInterfaceStyleChangeHandler)(JYTraitCollection *, BOOL) = nil;
static void (^_themeChangeHandler)(void) = nil;
@implementation JYTraitCollection


+ (JYTraitCollection *)traitCollectionWithUserInterfaceStyle:(JYInterfaceStyle)userInterfaceStyle {
    JYTraitCollection *traitCollection = [[JYTraitCollection alloc] init];
    traitCollection->_userInterfaceStyle = userInterfaceStyle;
    return traitCollection;
}

/*
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🎃🎃🎃🎃🎃🎃🎃 初始化相关 🎃🎃🎃🎃🎃🎃🎃🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 */
+ (void)setupEnvironmentWithConfiguration:(JYEnvironmentConfiguration *)configuration {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (@available(iOS 13.0, *)) {
      [UIScreen swizzleUIScreenTraitCollectionDidChange];
      [UIView swizzleTraitCollectionDidChangeToJYTraitCollectionDidChange];
      [UIViewController swizzleTraitCollectionDidChangeToJYTraitCollectionDidChange];
        if (!configuration.useImageAsset){
            [UIImage jy_swizzleIsEqual];
        }
    }
    else {
      [UIView jy_swizzleSetTintColor];
      [UIView jy_swizzleSetBackgroundColor];
      [UIImageView jy_swizzleSetImage];
      [UIImage  jy_swizzleIsEqual];
    }

    _themeChangeHandler = configuration.themeChangeHandler;
  });
}

+ (void)registerWithApplication:(UIApplication *)application animated:(BOOL)animated{
    
    __weak UIApplication *weakApp = application;
    __weak typeof(self) weakSelf = self;
    _userInterfaceStyleChangeHandler = ^(JYTraitCollection *traitCollection, BOOL animated) {
      __strong UIApplication *strongApp = weakApp;
      if (!strongApp)
        return;

      [weakSelf updateUIWithViews:strongApp.windows viewControllers:@[] traitCollection:traitCollection animated:animated];

      if (_themeChangeHandler)
        _themeChangeHandler();
    };
    //通知windows刷新
    [self observeNewWindowNotificationIfNeeded];
    
    if (_userInterfaceStyleChangeHandler)
      _userInterfaceStyleChangeHandler([self overrideTraitCollection], animated);
}


/*
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🎃🎃🎃🎃🎃🎃🎃 刷新相关 🎃🎃🎃🎃🎃🎃🎃🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 */
+ (void)updateUIWithViews:(NSArray<UIView *> *)views viewControllers:(NSArray<UIViewController *> *)viewControllers traitCollection:(JYTraitCollection *)traitCollection animated:(BOOL)animated {
    
  NSMutableArray<UIView *> *snapshotViews = nil;
  if (animated) {
    // Create snapshot views to ease the transition
    snapshotViews = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
      if (view.isHidden) // Skip hidden views
        return;

      UIView *snapshotView = [view snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
      if (!vc.isViewLoaded || vc.view.isHidden) // Skip view controllers that are not loaded and hidden views
        return;

      UIView *snapshotView = [vc.view snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [vc.view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];
  }

  [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
    if (@available(iOS 13.0, *)) {
      view.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
    }
    else {
      [view jyTraitCollectionDidChange:traitCollection];
    }
  }];

  [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
    if (@available(iOS 13.0, *)) {
      vc.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
    }
    else {
      [vc jyTraitCollectionDidChange:traitCollection];
    }
  }];

  if (animated) {
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.25 delay:0 options:0 animations:^{
      [snapshotViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = 0;
      }];
    } completion:^(UIViewAnimatingPosition finalPosition) {
      [snapshotViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
      }];
    }];
  }
}

+ (void)updateUIWithApplication:(UIApplication*)application traitCollection:(JYTraitCollection *)traitCollection animated:(BOOL)animated{
    UIApplication * app;
    if (application) {
        app = application;
    }else{
        app = [UIApplication sharedApplication];
    }

    [self updateUIWithViews:app.windows viewControllers:@[] traitCollection:traitCollection animated:animated];
}

+ (void)setOverrideTraitCollection:(JYTraitCollection *)overrideTraitCollection animated:(BOOL)animated {
  _overrideTraitCollection = overrideTraitCollection;
    if (_userInterfaceStyleChangeHandler)
      _userInterfaceStyleChangeHandler([self overrideTraitCollection], animated);
}

+ (void)setOverrideTraitCollectionStyle:(JYInterfaceStyle)interfaceStyle animated:(BOOL)animated{
    _overrideTraitCollection = [JYTraitCollection traitCollectionWithUserInterfaceStyle:interfaceStyle];
    if (_userInterfaceStyleChangeHandler)
      _userInterfaceStyleChangeHandler([self overrideTraitCollection], animated);
}


/*
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🎃🎃🎃🎃🎃🎃🎃 通知相关 🎃🎃🎃🎃🎃🎃🎃🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 */
+ (void)observeNewWindowNotificationIfNeeded {
  if (_isObservingNewWindowAddNotification)
    return;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

+ (void)windowDidBecomeVisible:(NSNotification *)notification {
  NSObject *object = [notification object];
  if ([object isKindOfClass:[UIWindow class]])
    [self updateUIWithViews:@[(UIWindow *)object] viewControllers:@[] traitCollection:[self overrideTraitCollection] animated:NO];
}

 
/*
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🎃🎃🎃🎃🎃🎃🎃 获取当前样式 🎃🎃🎃🎃🎃🎃🎃🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 */
+ (JYTraitCollection *)currentSystemTraitCollection API_AVAILABLE(ios(13.0)) {
  return [JYTraitCollection traitCollectionWithUITraitCollection:UIScreen.mainScreen.traitCollection];
}

// 转换为系统的
- (UITraitCollection *)uiTraitCollection {
  UIUserInterfaceStyle style = UIUserInterfaceStyleUnspecified;
  switch (_userInterfaceStyle) {
    case JYInterfaceStyleLight:
      style = UIUserInterfaceStyleLight;
      break;
    case JYInterfaceStyleDark:
      style = UIUserInterfaceStyleDark;
      break;
    case JYInterfaceStyleUnspecified:
    default:
      style = UIUserInterfaceStyleUnspecified;
      break;
  }
  return [UITraitCollection traitCollectionWithUserInterfaceStyle:style];
}

+ (JYTraitCollection *)traitCollectionWithUITraitCollection:(UITraitCollection *)traitCollection {
  JYInterfaceStyle style = JYInterfaceStyleUnspecified;
  switch (traitCollection.userInterfaceStyle) {
    case UIUserInterfaceStyleLight:
      style = JYInterfaceStyleLight;
      break;
    case UIUserInterfaceStyleDark:
      style = JYInterfaceStyleDark;
      break;
    case UIUserInterfaceStyleUnspecified:
    default:
      style = JYInterfaceStyleUnspecified;
      break;
  }
  return [self traitCollectionWithUserInterfaceStyle:style];
}

/*
 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🎃🎃🎃🎃🎃🎃🎃 Lazy 🎃🎃🎃🎃🎃🎃🎃🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
 */
+ (JYTraitCollection *)currentTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [JYTraitCollection traitCollectionWithUITraitCollection:UITraitCollection.currentTraitCollection];
  }
  return [self overrideTraitCollection];
}


+ (JYTraitCollection *)overrideTraitCollection {
  if (!_overrideTraitCollection) {
    _overrideTraitCollection = [JYTraitCollection traitCollectionWithUserInterfaceStyle:JYInterfaceStyleUnspecified];
  }
  return _overrideTraitCollection;
}


- (instancetype)init {
  self = [super init];
  if (self) {
    _userInterfaceStyle = JYInterfaceStyleUnspecified;
  }
  return self;
}

@end
