//
//  NSObject+JYTraitEnviroment.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/11.
//

#import "NSObject+JYTraitEnviroment.h"
#import <objc/message.h>
#import "JYTraitCollection.h"

@implementation NSObject (JYTraitEnviroment)

+ (void)swizzleTraitCollectionDidChangeToJYTraitCollectionDidChange {
    if (@available(iOS 13.0, *)) {
        [self swizzleTraitCollectionDidChangeToJYTraitCollectionDidChangeWithBlock:nil];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)swizzleTraitCollectionDidChangeToJYTraitCollectionDidChangeWithBlock:(void (^)(id<UITraitEnvironment>, UITraitCollection *))block API_AVAILABLE(ios(13.0)) {
  // Only swizzling classes that conforms to both UITraitEnvironment & DMTraitEnvironment
  if (!class_conformsToProtocol(self, @protocol(UITraitEnvironment)) || !class_conformsToProtocol(self, @protocol(JYTraitEnvironment))) {
    return;
  }

  SEL selector = @selector(traitCollectionDidChange:);
  Method method = class_getInstanceMethod(self, selector);

  if (!method)
    NSAssert(NO, @"Method not found for [%@ traitCollectionDidChange:]", NSStringFromClass(self));

  IMP imp = method_getImplementation(method);
  class_replaceMethod(self, selector, imp_implementationWithBlock(^(id<UITraitEnvironment> self, UITraitCollection *previousTraitCollection) {
    // Call previous implementation
    ((void (*)(NSObject *, SEL, UITraitCollection *))imp)(self, selector, previousTraitCollection);

    // Call JYTraitEnvironment method
    [(id <JYTraitEnvironment>)self jyTraitCollectionDidChange:previousTraitCollection == nil ? nil : [JYTraitCollection traitCollectionWithUITraitCollection:previousTraitCollection]];

    // Call custom block
    if (block) {
      block(self, previousTraitCollection);
    }
  }), method_getTypeEncoding(method));
}

  @end
