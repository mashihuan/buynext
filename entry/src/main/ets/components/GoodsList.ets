import { promptAction, router } from "@kit.ArkUI"
import { BASE_URL } from "../common/Config"
import { CartModel } from "../viewmodel/CartModel"
import { GoodsItem } from "../viewmodel/GoodsModel"
import { CategoryTitle } from "./CategoryTitle"
import { emitterUtil, EmitterEventId } from "../utils/EmitterUtil"


@Component
export struct GoodsList {
  title: ResourceStr = ''
  banner: ResourceStr = ''
  @Link goodsList: GoodsItem[]

  async onAddToCart(goods: GoodsItem) {
    // 查询数据库，是否已有该商品
    const res = await CartModel.queryByGoodsId(goods.id)
    // 已有，直接+1
    if(res.length) {
      await CartModel.update({
        id: res[0].id,
        num: res[0].num + 1
      })
    }else {
      await CartModel.insert({
        goods_id: goods.id,
        num: 1,
      })
    }
    emitterUtil.emit({eventId: EmitterEventId.ADD_TO_CART})
    promptAction.showToast({message: '加入购物车成功'})
  }

  build() {
    Column() {
      if(this.title) {
        CategoryTitle({title: this.title})
      }
      if(this.banner) {
        Image(this.banner)
          .width('100%')
          .height(165)
          .margin({bottom: 12})
      }
      List({space: 5}) {
        ForEach(this.goodsList, (goods: GoodsItem) => {
          ListItem() {
            Column({space: 3}) {
              Column({space: 3}) {
                Image(BASE_URL + goods.icon)
                  .width(120)
                  .height(120)
                Text(goods.desc)
                  .fontSize(13)
                  .fontColor($r('app.color.text_color'))
                  .lineHeight(17)
                  .maxLines(2)
                  .textOverflow({overflow: TextOverflow.Ellipsis})
                Text(`¥${goods.new_price.toFixed(1)}`)
                  .fontSize(13)
                  .fontColor($r('app.color.price_color_new'))
                  .fontWeight(FontWeight.Bold)
              }
              .alignItems(HorizontalAlign.Start)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/GoodsDetail',
                  params: {goods_id: goods.id}
                })
              })
              Row() {
                Text(`￥${goods.old_price.toFixed(1)}`)
                  .fontSize(13)
                  .fontColor($r('app.color.price_color_old'))
                  .fontWeight(FontWeight.Bold)
                  .decoration({type: TextDecorationType.LineThrough, color: $r('app.color.price_color_old')})
                Image($r('app.media.icon_cart'))
                  .width(22)
                  .height(22)
                  .margin({right: 10})
                  .onClick(() => {
                    this.onAddToCart(goods)
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width(120)
            .alignItems(HorizontalAlign.Start)
          }
        }, (goods: GoodsItem) => goods.id + '')
      }
      .width('100%')
      .height(200)
      .listDirection(Axis.Horizontal)
    }
    .width('100%')
    .padding(12)
    .margin({bottom: 12})
    .backgroundColor('#fff')
  }
}