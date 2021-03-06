<div align="center">

TPreventUnrecognizedSEL
------

</div>

<div align="center">

![platform](https://img.shields.io/badge/Platform-iOS%20%7C%20tvOS%20%7C%20macOS%20%7C%20watchOS-brightgreen.svg)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg?style=flat)](http://cocoapods.org/)&nbsp;
[![Build Status](https://travis-ci.org/tobedefined/TPreventUnrecognizedSEL.svg?branch=master)](https://travis-ci.org/tobedefined/TPreventUnrecognizedSEL)&nbsp;
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/tobedefined/TPreventUnrecognizedSEL/blob/master/LICENSE)

</div>

<div align="center">

[English Document](README.md)

[TPreventUnrecognizedSEL的实现原理](http://tbd.ink/2017/11/26/iOS/17112601.TPreventUnrecognizedSEL%E5%AE%9E%E7%8E%B0%E6%80%9D%E8%B7%AF%E4%BB%A5%E5%8F%8A%E5%8E%9F%E7%90%86/index/)

</div>

### 特点

- 使用runtime动态添加方法防止产生`Unrecognized Selector`错误，可以防止因为对象方法和类方法缺失所产生的APP崩溃。
    > 对象方法：`*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[TestClass losted:instance:method:]: unrecognized selector sent to instance 0x102c....'`
    > 
    > 类方法：`*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '+[TestClass losted:class:method:]: unrecognized selector sent to class 0x10000....'`

- 可以获取缺失方法的具体信息，包括：
    - 缺失类方法或对象方法的类名；
    - 所缺失的方法名；
    - 缺失的是对象方法还是类方法。

### 如何导入

#### 源文件

源文件中包含两个模块目录： `TPUSELNormalForwarding` 和 `TPUSELFastForwarding`；将对应模块目录中的`Sources`文件夹内部的所有文件拖入项目中即可

**⚠️注意：你只可以使用其中一个模块进行使用，将对应模块目录中的Sources文件内部的所有文件拖入项目中即可，推荐使用`TPUSELNormalForwarding`，因为系统的某些方法使用了快速转发FastForwarding技术**

#### CocoaPods

[`CocoaPods`](https://cocoapods.org/)是一个Cocoa项目管理器。你可以使用以下命令去安装`CocoaPods`:

```bash
$ gem install cocoapods
```

要使用CocoaPods将`TPreventUnrecognizedSEL`集成到您的Xcode项目中，请在`Podfile`中加入：

```ruby
# pod 'TPreventUnrecognizedSEL' 默认是使用 pod 'TPreventUnrecognizedSEL/NormalForwarding'
pod 'TPreventUnrecognizedSEL/NormalForwarding'
```

或者加入

```ruby
pod 'TPreventUnrecognizedSEL/FastForwarding'
```

然后运行一下命令:

```bash
$ pod install
```

**⚠️注意：你只可以使用其中一个subspec，`NormalForwarding` 和 `FastForwarding` 二者只能选其一** 

**⚠️使用`pod 'TPreventUnrecognizedSEL'`默认是`pod 'TPreventUnrecognizedSEL/NormalForwarding'`**

#### Carthage


[`Carthage`](https://github.com/Carthage/Carthage)是一个去中心化的依赖管理器，它构建并提供所使用的库的framework。

你可以使用 [`Homebrew`](https://brew.sh/)并运行下面的命令安装Carthage

```bash
$ brew update
$ brew install carthage
```

要将`TPreventUnrecognizedSEL`集成到使用Carthage的Xcode项目中，请在`Cartfile`中加入：

```ruby
github "tobedefined/TPreventUnrecognizedSEL"
```

运行`carthage update`构建framework，并将编译的对应平台的`TPUSELNormalForwarding.framework`或者`TPUSELFastForwarding.framework`拖入Xcode项目中。

**⚠️注意：你只可以使用其中一个framework，`TPUSELNormalForwarding.framework` 和 `TPUSELFastForwarding.framework`二者选一**

### 使用方法

#### 简单使用

导入项目之后简单设置对哪些Class进行forwarding即可。

#### 运行错误信息获取

##### 导入头文件

|   模块和语言 \ 导入模块方式        |               源文件               |                            CocoaPods                             |                            Carthage                             |
| :----------------------------: | :--------------------------------: | :--------------------------------------------------------------: | :-------------------------------------------------------------: |
| TPUSELNormalForwarding & ObjC  | #import "TPUSELNormalForwarding.h" | #import &lt;TPreventUnrecognizedSEL/TPUSELNormalForwarding.h&gt; | #import &lt;TPUSELNormalForwarding/TPUSELNormalForwarding.h&gt; |
| TPUSELNormalForwarding & Swift |     add ⤴ in Bridging-Header      |                  import TPreventUnrecognizedSEL                  |                  import TPUSELNormalForwarding                  |
|  TPUSELFastForwarding & ObjC   |  #import "TPUSELFastForwarding.h"  |  #import &lt;TPreventUnrecognizedSEL/TPUSELFastForwarding.h&gt;  |   #import &lt;TPUSELFastForwarding/TPUSELFastForwarding.h&gt;   |
|  TPUSELFastForwarding & Swift  |      add ⤴ in Bridging-Header     |                  import TPreventUnrecognizedSEL                  |                   import TPUSELFastForwarding                   |

##### 设置forwarding以及Block

在APP的 **`main.m`文件的`main()`函数中** 或者 **在APP的`didFinishLaunching`方法中** 加入以下代码可以获得缺失方法的具体信息：

###### TPUSELNormalForwarding

```objc
// 设置不对NSNull及其子类进行处理，默认为NO
[NSObject setIgnoreForwardNSNullClass:YES];
// 设置不对数组中的类及其子类进行处理（数组中的类名可以为Class类型也可以为NSString类型），默认不忽略任何类
[NSObject setIgnoreForwardClassArray:@[@"SomeIgnoreClass1", [SomeIgnoreClass2 Class]]];
// 设置仅处理数组中的类及其子类（数组中的类名可以为Class类型也可以为NSString类型），默认处理所有类
[NSObject setJustForwardClassArray:@[@"SomeClass1", [SomeClass2 Class]]];
// 设置处理之后的回调操作
[NSObject setHandleUnrecognizedSELErrorBlock:^(Class  _Nonnull __unsafe_unretained cls, SEL  _Nonnull selector, UnrecognizedMethodType methodType, NSArray<NSString *> * _Nonnull callStackSymbols) {
    // 在这里写你要做的事情
    // 比如上传到服务器或者打印log等
}];
```

###### TPUSELFastForwarding

```objc
// 设置仅处理数组中的类及其子类（数组中的类名可以为Class类型也可以为NSString类型），默认不处理任何类
// 设置处理之后的回调操作
[NSObject setJustForwardClassArray:@[@"SomeClass1", [SomeClass2 Class]]
           handleUnrecognizedSELErrorBlock:^(Class  _Nonnull __unsafe_unretained cls, SEL  _Nonnull selector, UnrecognizedMethodType methodType, NSArray<NSString *> * _Nonnull callStackSymbols) {
              // 在这里写你要做的事情
              // 比如上传到服务器或者打印log等
           }];
```


##### 一些定义

在`NSObject+TPUSELFastForwarding.h`或者`NSObject+TPUSELNormalForwarding.h`中有以下定义和方法

```objc
typedef NS_ENUM(NSUInteger, UnrecognizedMethodType) {
    UnrecognizedMethodTypeClassMethod       = 1,
    UnrecognizedMethodTypeInstanceMethod    = 2,
};

typedef void (^ __nullable HandleUnrecognizedSELErrorBlock)(Class cls,
                                                            SEL selector,
                                                            UnrecognizedMethodType methodType,
                                                            NSArray<NSString *> *callStackSymbols);
```

- `cls`: `Class`类型；为缺失方法的类或对象的Class，可使用`NSStringFromClass(cls)`返回类名字符串
- `selector`: `SEL`类型；为所缺失的方法名，可使用`NSStringFromSelector(selector)`返回方法名的字符串
- `methodType`: `UnrecognizedMethodType`类型；为所缺失的方法类型（类方法or对象方法）
- `callStackSymbols`: `NSArray<NSString *> *`类型；为调用栈信息

