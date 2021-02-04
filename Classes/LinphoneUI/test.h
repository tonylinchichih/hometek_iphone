//
//  test.h
//  linphone
//
//  Created by Lai Lee on 2020/7/8.
//

#ifndef test_h
#define test_h

@interface UICompositeViewDescription : NSObject {
}

@property(strong) NSString *name;
@property(strong) NSString *statusBar;
@property(strong) NSString *tabBar;
@property(strong) NSString *sideMenu;
@property(strong) NSString *otherFragment;
@property(assign) BOOL statusBarEnabled;
@property(assign) BOOL tabBarEnabled;
@property(assign) BOOL sideMenuEnabled;
@property(assign) BOOL fullscreen;
@property(assign) BOOL isLeftFragment;
@property(assign) BOOL darkBackground;
@property(assign) BOOL landscapeMode;
@property(assign) BOOL portraitMode;

- (id)copy;
- (BOOL)equal:(UICompositeViewDescription *)description;
- (id)init:(Class)name
         statusBar:(Class)statusBar
            tabBar:(Class)tabBar
          sideMenu:(Class)sideMenu
        fullscreen:(BOOL)fullscreen
    isLeftFragment:(BOOL)isLeftFragment
      fragmentWith:(Class)otherFragment;

@end

@protocol UICompositeViewDelegate <NSObject>

+ (UICompositeViewDescription *)compositeViewDescription;
- (UICompositeViewDescription *)compositeViewDescription;

@end

#endif /* test_h */
