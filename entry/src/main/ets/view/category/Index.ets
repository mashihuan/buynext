import { requestCategoryList } from "../../api/Category"
import { requestGoodsList } from "../../api/Goods"
import { BASE_URL } from "../../common/Config"
import { IGoodsListByCategoryParams } from "../../utils/Types"
import { CategoryItem } from "../../viewmodel/CategoryModel"
import { GoodsItem } from "../../viewmodel/GoodsModel"
import { CategorySearch } from "./Search"
import { router } from "@kit.ArkUI"

@Component
export struct CategoryIndex {
  @State categoryList: CategoryItem[] = []
  @Consume @Watch('getGoodsListByCategory') categoryId: number
  @State goodsList: GoodsItem[] = []

  aboutToAppear(): void {
    this.getCategoryList()
  }

  async getCategoryList() {
    const res = await requestCategoryList<CategoryItem[], null>()
    this.categoryList = res.data.categorys || []
    if(this.categoryList.length) {
      if(!this.categoryId) {
        this.categoryId = this.categoryList[0].id
      }
      this.getGoodsListByCategory()
    }
  }

  async getGoodsListByCategory() {
    if(!this.categoryList.length) {
      this.getCategoryList()
      return
    }
    const res = await requestGoodsList<GoodsItem[], IGoodsListByCategoryParams>({
      category_id: this.categoryId
    })
    this.goodsList = res.data.goods || []
  }

  build() {
    Column() {
      CategorySearch()
      Row() {
        List() {
          ForEach(this.categoryList, (category: CategoryItem) => {
            ListItem() {
              Text(category.name)
                .width('100%')
                .height(55)
                .textAlign(TextAlign.Center)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
                .backgroundColor(this.categoryId === category.id ? '#fff' : '')
                .onClick(() => this.categoryId = category.id)
            }
          }, (category: CategoryItem) => category.id + '')
        }
        .width('25%')
        .height('100%')
        Grid() {
          ForEach(this.goodsList, (goods: GoodsItem) => {
            GridItem() {
              Column({space: 10}) {
                Image(BASE_URL + goods.icon)
                  .width(70)
                  .height(70)
                  .objectFit(ImageFit.Cover)
                Text(goods.name)
                  .fontSize($r('app.float.font_size'))
                  .fontColor($r('app.color.text_color'))
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/GoodsDetail',
                  params: {
                    goods_id: goods.id
                  }
                })
              })
            }
          }, (goods: GoodsItem) => goods.id + '')
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(16)
        .layoutWeight(1)
        .height('100%')
        .padding({top: 16, bottom: 16})
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}