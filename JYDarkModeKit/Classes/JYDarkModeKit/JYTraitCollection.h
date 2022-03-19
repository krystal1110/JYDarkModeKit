//
//  JYTraitCollection.h
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JYEnvironmentConfiguration.h"
 
typedef NS_ENUM(NSInteger, JYInterfaceStyle) {
  JYInterfaceStyleUnspecified,
  JYInterfaceStyleLight,
  JYInterfaceStyleDark,
};

NS_ASSUME_NONNULL_BEGIN

static void (^_windowThemeChangeHandler)(UIWindow *) = nil;

@interface JYTraitCollection : NSObject
 
// iOS 13使用
@property (class, nonatomic, readonly) JYTraitCollection * currentTraitCollection;

@property (nonatomic, readonly) JYInterfaceStyle userInterfaceStyle;

@property (class, nonatomic, readonly) JYTraitCollection *overrideTraitCollection;

/*
 注册方法
 需要在AppDelegate当中设置
 **/
+ (void)registerWithApplication:(UIApplication *)application animated:(BOOL)animated;

// 当前JYTraitCollection
+ (JYTraitCollection *)currentSystemTraitCollection API_AVAILABLE(ios(13.0));




/*
 刷新视图
 修改当前样式 需要传入一个JYInterfaceStyle枚举
 **/
+ (void)setOverrideTraitCollectionStyle:(JYInterfaceStyle)interfaceStyle animated:(BOOL)animated;


/*
 更改当前的Style
 **/
+ (JYTraitCollection *)traitCollectionWithUserInterfaceStyle:(JYInterfaceStyle)userInterfaceStyle;

+ (JYTraitCollection *)traitCollectionWithUITraitCollection:(UITraitCollection *)traitCollection API_AVAILABLE(ios(13.0));

 
 

// 获取系统当前的UITraitCollection
- (UITraitCollection *)uiTraitCollection;


+ (void)setupEnvironmentWithConfiguration:(JYEnvironmentConfiguration *)configuration;

@end

@protocol JYTraitEnvironment <NSObject>

@property (readonly) JYTraitCollection *jyTraitCollection;

- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection;

 

@end

NS_ASSUME_NONNULL_END
