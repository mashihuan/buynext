import { requestGoodsList } from "../../api/Goods"
import { GoodsList } from "../../components/GoodsList"
import { IGoodsListByCategoryParams } from "../../utils/Types"
import { GoodsItem } from "../../viewmodel/GoodsModel"

import { HomeBanner } from "./Banner"
import { HomeGrid } from "./Grid"
import { HomeHeader } from "./Header"

@Component
export struct HomeIndex {
  @State newGoodsList: GoodsItem[] = []
  @State freshGoodsList: GoodsItem[] = []
  @State riceGoodsList: GoodsItem[] = []

  aboutToAppear(): void {
    this.getNewGoodsList()
    this.getFreshGoodsList()
    this.getRiceGoodsList()
  }

  async getNewGoodsList() {
    const res = await requestGoodsList<GoodsItem[], IGoodsListByCategoryParams>({
      category_id: 1,
    })
    this.newGoodsList = res.data.goods
  }

  async getFreshGoodsList() {
    const res = await requestGoodsList<GoodsItem[], IGoodsListByCategoryParams>({
      category_id: 2,
    })
    this.freshGoodsList = res.data.goods || []
  }

  async getRiceGoodsList() {
    const res = await requestGoodsList<GoodsItem[], IGoodsListByCategoryParams>({
      category_id: 3,
    })
    this.riceGoodsList = res.data.goods || []
  }

  build() {
    Column() {
      HomeHeader()
      Scroll() {
        Column() {
          HomeBanner()
          HomeGrid()
          GoodsList({title: '新品尝鲜', banner: $r('app.media.banner_new'), goodsList: this.newGoodsList})
          GoodsList({title: '优质新鲜', banner: $r('app.media.banner_fresh'), goodsList: this.freshGoodsList})
          GoodsList({title: '粮油米面', banner: $r('app.media.banner_rice'), goodsList: this.riceGoodsList})
        }
      }
      .padding({bottom: 78})
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}