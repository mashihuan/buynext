import { HomeIndex } from '../view/home/Index'
import { CategoryIndex } from '../view/category/Index'
import { CartIndex } from '../view/cart/Index'
import { MenuIndex } from '../view/menu/Index'
import { MineIndex } from '../view/mine/Index'
import { GoodsItem, GoodsModel } from '../viewmodel/GoodsModel'
import { requestGoodsList } from '../api/Goods'

@Entry
@Component
struct Index {
  @Provide currentIndex: number = 0
  @Provide categoryId: number = 0

  aboutToAppear(): void {
    this.getGoodsList()
  }

  async getGoodsList() {
    const res = await requestGoodsList<GoodsItem[], null>()
    const goodsList = res.data.goods
    await GoodsModel.batchInsert(goodsList)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomeIndex()
        }
        .tabBar(this.TabBuilder($r('app.media.home'), $r('app.media.home_active'), '首页', 0))

        TabContent() {
          CategoryIndex()
        }
        .tabBar(this.TabBuilder($r('app.media.category'), $r('app.media.category_active'), '分类', 1))

        TabContent() {
          MenuIndex()
        }
        .tabBar(this.TabBuilder($r('app.media.menu'), $r('app.media.menu_active'), '吃什么', 2))

        TabContent() {
          CartIndex()
        }
        .tabBar(this.TabBuilder($r('app.media.cart'), $r('app.media.cart_active'), '购物车', 3))

        TabContent() {
          MineIndex()
        }
        .tabBar(this.TabBuilder($r('app.media.mine'), $r('app.media.mine_active'), '我的', 4))
      }
      .vertical(false)
      .scrollable(false)
      .barMode(BarMode.Fixed)
      .animationMode(AnimationMode.NO_ANIMATION)
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder TabBuilder(icon: ResourceStr, activeIcon: ResourceStr, text: ResourceStr, index: number) {
    Column() {
      Image(this.currentIndex === index ? activeIcon : icon)
        .width(24)
        .height(24)
      Text(text)
        .margin({ top: 3 })
        .fontSize(10)
        .fontColor(this.currentIndex === index ? $r('app.color.color_primary') : $r('app.color.text_color'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}