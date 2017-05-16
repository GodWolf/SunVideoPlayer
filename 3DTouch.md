**3DTouch是iOS9出的新特性，用户可以在手机主屏幕和app内部使用**

### 1. 主屏幕的快捷操作###

当用户按压应用图标是会弹出快捷操作列表，当用户选择选择一个快捷操作是，应用会被激活或者启动，同事你的代理对象会收到快捷操作的信息。

![image: ../Art/maps_directions_home_2x.png](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/Art/maps_directions_home_2x.png)

- **固定的快捷操作:**需要在`Info.plist`里设置 [UIApplicationShortcutItems](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW36) 
- **动态的快捷操作:**需要使用`UIApplicationShortcutItem`类和相关方法创建快捷操作，并设置`UIApplication`的`shortcutItems`的属性

### 2. 应用内使用###

当用户按压时会经历三个阶段:

- 看看内容预览是否有效
- 展示预览内容
- pop出内容预览页面

![image: ../Art/preview_available_2_2x.png](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/Art/preview_available_2_2x.png)

![image: ../Art/peek_2x.png](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/Art/peek_2x.png)

![image: ../Art/peek_quick_actions_2x.png](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/Art/peek_quick_actions_2x.png)

### 3. 使用

- **检查3D-Touch是否可用**

```objective-c
//通过forceTouchCapability属性判断3DTousch是否可用 
//UIForceTouchCapabilityUnknown、UIForceTouchCapabilityUnavailable、UIForceTouchCapabilityAvailable
//实现UITraitEnvironment协议的类都可以直接调用，UIScreen、UIWindow、UIViewController、UIView都实现了该协议
if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
  NSLog(@"可用");
}

//重写该方法可以监听状态改变改变
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection
  
如果3DTouch不可用需要自己写 UILongPressGestureRecognizer来代替
```

- **主屏幕快捷操作—固定的快捷操作**

  需要在`Info.plist`文件中添加`UIApplicationShortcutItems`

  ![屏幕快照 2017-05-16 下午2.39.31](/Users/sunxingxiang/Desktop/屏幕快照 2017-05-16 下午2.39.31.png)

  *UIApplicationShortcutItemType*快捷操作的类型，需要这个识别快捷操作

  *UIApplicationShortcutItemTitle*快捷操作的标题

  *UIApplicationShortcutItemSubtitle*快捷操作的子标题

  *UIApplicationShortcutItemIconType*快捷操作的图标

  ```objective-c
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // Override point for customization after application launch.
  	//如果程序被杀掉，在这里拿到快捷操作
      if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
      
          UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
          if(shortcutItem){
              //根据type判断要指定哪个操作
          }
      }
      return YES;
  }

  //设置完plist文件后需要在appdelegate中重写该方法
  - (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //根据type来判断执行不同的操作
      if([shortcutItem.type isEqualToString:@"search"]){
          NSLog(@"search");
      }else if([shortcutItem.type isEqualToString:@"open"]){
          NSLog(@"open");
      }
      completionHandler(YES);
  }
  ```

  ​


- **主屏幕快捷操作——— 动态的快捷操作**

  ```objective-c
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // Override point for customization after application launch.

      if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
      
          UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
          if(shortcutItem == nil){
              UIApplicationShortcutItem *firstItem = [[UIApplicationShortcutItem alloc] initWithType:@"first" localizedTitle:@"第一个" localizedSubtitle:@"子标题" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"sun1"] userInfo:nil];
              UIApplicationShortcutItem *secondItem = [[UIApplicationShortcutItem alloc] initWithType:@"second" localizedTitle:@"第二个" localizedSubtitle:@"子标题" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"sun2"] userInfo:nil];
              application.shortcutItems = @[firstItem,secondItem];
          }else{
              
              //根据type判断要指定哪个操作
          }
      }
      
      return YES;
  }
  //自定义图标需要正方形，单一颜色，35*35的图才可以使用
  ```


- **应用内使用**

  应用内使用3DTouch需要使用 `UIPreviewAction`和 `UIPreviewActionGroup`类以及 `UIPreviewActionItem`协议