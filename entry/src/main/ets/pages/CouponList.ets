import { NavigationBar } from '../components/NavigationBar'
import { CouponListData } from '../view/couponlist/ListData'
import { CouponItem } from '../viewmodel/CouponModel'

@Entry
@Component
struct CouponList {
  private controller: TabsController = new TabsController()
  @State currentTabIndex: number = 0
  @State couponListArray: Array<CouponItem[]> = []

  @Builder tabBarBuilder(text: string, index: number) {
    Column() {
      Text(text)
        .height('100%')
        .padding({right: 10, left: 10})
        .fontSize($r('app.float.font_size'))
        .fontColor($r('app.color.text_color'))
        .border({color: this.currentTabIndex === index ? $r('app.color.color_primary') : 'transparent', width: {bottom: 2}})
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#fff')
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
  }

  build() {
    Column() {
      NavigationBar({title: '优惠券'})
      Tabs({controller: this.controller, index: this.currentTabIndex}) {
        TabContent() {
          CouponListData({couponList: this.couponListArray[0]})
        }
        .tabBar(this.tabBarBuilder('未使用', 0))
        TabContent() {
          CouponListData({couponList: this.couponListArray[1]})
        }
        .tabBar(this.tabBarBuilder('已使用', 1))
        TabContent() {
          CouponListData({couponList: this.couponListArray[2]})
        }
        .tabBar(this.tabBarBuilder('已过期', 2))
      }
      .barHeight(46)
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color'),
        startMargin: 0,
        endMargin: 0
      })
      .onAnimationStart((_: number, targetIndex: number) => {
        setTimeout(() => {
          this.currentTabIndex = targetIndex
        }, 100)
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}