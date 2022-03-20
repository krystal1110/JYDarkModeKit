# JYDarkModeKit

[![CI Status](https://img.shields.io/travis/jingyu.liao/JYDarkModeKit.svg?style=flat)](https://travis-ci.org/jingyu.liao/JYDarkModeKit)
[![Version](https://img.shields.io/cocoapods/v/JYDarkModeKit.svg?style=flat)](https://cocoapods.org/pods/JYDarkModeKit)
[![License](https://img.shields.io/cocoapods/l/JYDarkModeKit.svg?style=flat)](https://cocoapods.org/pods/JYDarkModeKit)
[![Platform](https://img.shields.io/cocoapods/p/JYDarkModeKit.svg?style=flat)](https://cocoapods.org/pods/JYDarkModeKit)


##  JYDarkModeKit主要功能：适配夜间模式，iOS10以上的系统均能适配，实时更新页面

## Example

JYDarkModeKit is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'JYDarkModeKit'
```

### 使用教程

导入头文件

```C
#import "JYDarkModeKit.h"
```



在`AppDelegate`进行初始化工作

```objective-c
JYEnvironmentConfiguration * configuration = [JYEnvironmentConfiguration 
                                              initWithThemeChangeHandler:^{
        NSLog(@"themeChangeHandler");
    }];    
[JYTraitCollection setupEnvironmentWithConfiguration:configuration];
[JYTraitCollection registerWithApplication:application animated:YES];
```



设置背景颜色

```objective-c
self.view.backgroundColor = [UIColor jy_colorWithLightColor:[UIColor yellowColor] darkColor:[UIColor orangeColor]];
```



设置图片

```objective-c
UIImageView * imageView =  [[UIImageView alloc]initWithFrame:CGRectMake(50, 550, 100, 50)];
   
[imageView setImage:[UIImage jy_imageWithLightImage:[UIImage imageNamed:@"test3"] darkImage:[UIImage imageNamed:@"test"]]];
```



修改颜色

```objective-c
///普通模式
[JYTraitCollection setOverrideTraitCollectionStyle:JYInterfaceStyleLight animated:YES];
 
///夜间模式  
[JYTraitCollection setOverrideTraitCollectionStyle:JYInterfaceStyleDark animated:YES];
```



获取当前样式

```objective-c
///iOS13以上通过
[JYTraitCollection currentTraitCollection].uiTraitCollection.userInterfaceStyle 
  
///iOS13以下  
JYTraitCollection.overrideTraitCollection.userInterfaceStyle
  
```



## Author

JY

## License

JYDarkModeKit is available under the MIT license. See the LICENSE file for more info.
