/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "XCTestPrivateSymbols.h"
#include <dlfcn.h>
#import <objc/runtime.h>

NSNumber *FB_XCAXAIsVisibleAttribute;
NSNumber *FB_XCAXAIsElementAttribute;

void *FBRetrieveSymbolFromBinary(const char *binary, const char *name);
void (*XCSetDebugLogger)(id <XCDebugLogDelegate>);
id<XCDebugLogDelegate> (*XCDebugLogger)(void);


void *FBRetrieveSymbolFromBinary(const char *binary, const char *name)
{
    void *handle = dlopen(binary, RTLD_LAZY);
    NSCAssert(handle, @"%s could not be opened", binary);
    void *pointer = dlsym(handle, name);
    NSCAssert(pointer, @"%s could not be located", name);
    return pointer;
}

__attribute__((constructor)) void FBLoadXCTestSymbols(void)
{
  NSString *XC_kAXXCAttributeIsVisible = *(NSString*__autoreleasing*)FBRetrieveXCTestSymbol("XC_kAXXCAttributeIsVisible");
  NSString *XC_kAXXCAttributeIsElement = *(NSString*__autoreleasing*)FBRetrieveXCTestSymbol("XC_kAXXCAttributeIsElement");

  NSArray *(*XCAXAccessibilityAttributesForStringAttributes)(NSArray *list) =
  (NSArray<NSNumber *> *(*)(NSArray *))FBRetrieveXCTestSymbol("XCAXAccessibilityAttributesForStringAttributes");

  XCSetDebugLogger = (void (*)(id <XCDebugLogDelegate>))FBRetrieveXCTestSymbol("XCSetDebugLogger");
  XCDebugLogger = (id<XCDebugLogDelegate>(*)(void))FBRetrieveXCTestSymbol("XCDebugLogger");

  NSArray<NSNumber *> *accessibilityAttributes = XCAXAccessibilityAttributesForStringAttributes(@[XC_kAXXCAttributeIsVisible, XC_kAXXCAttributeIsElement]);
  FB_XCAXAIsVisibleAttribute = accessibilityAttributes[0];
  FB_XCAXAIsElementAttribute = accessibilityAttributes[1];

  NSCAssert(FB_XCAXAIsVisibleAttribute != nil , @"Failed to retrieve FB_XCAXAIsVisibleAttribute", FB_XCAXAIsVisibleAttribute);
  NSCAssert(FB_XCAXAIsElementAttribute != nil , @"Failed to retrieve FB_XCAXAIsElementAttribute", FB_XCAXAIsElementAttribute);
}

void *FBRetrieveXCTestSymbol(const char *name)
{
  Class XCTestClass = NSClassFromString(@"XCTestCase");
  NSCAssert(XCTestClass != nil, @"XCTest should be already linked", XCTestClass);
  NSString *XCTestBinary = [NSBundle bundleForClass:XCTestClass].executablePath;
  const char *binaryPath = XCTestBinary.UTF8String;
  NSCAssert(binaryPath != nil, @"XCTest binary path should not be nil", binaryPath);
  return FBRetrieveSymbolFromBinary(binaryPath, name);
}
