import { requestGoodsList } from "../../api/Goods"
import { requestMenuList } from "../../api/Menu"
import { GoodsList } from "../../components/GoodsList"
import { NavigationBar } from "../../components/NavigationBar"
import { IGoodsListByCategoryParams } from "../../utils/Types"
import { GoodsItem } from "../../viewmodel/GoodsModel"
import { MenuItem } from "../../viewmodel/MenuModel"
import { MenuList } from "./MenuList"

@Component
export struct MenuIndex {
  @State goodsList: GoodsItem[] = []
  @State menuList: MenuItem[] = []

  aboutToAppear(): void {
    this.getGoodsList()
    this.getMenuList()
  }

  async getGoodsList() {
    const res = await requestGoodsList<GoodsItem[], IGoodsListByCategoryParams>( {
      category_id: 4
    })
    this.goodsList = res.data.goods || []
  }

  async getMenuList() {
    const res = await requestMenuList<MenuItem[], null>()
    this.menuList = res.data.menus || []
  }

  build() {
    Column() {
      NavigationBar({title: '吃什么', hiddenBack: true})
      Scroll() {
        Column() {
          GoodsList({title: '季节菜谱', goodsList: this.goodsList})
          MenuList({menuList: this.menuList})
        }
        .padding({bottom: 54})
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}