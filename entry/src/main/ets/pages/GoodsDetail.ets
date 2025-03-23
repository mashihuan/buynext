import { promptAction, router } from '@kit.ArkUI'
import { requestGoodsById } from '../api/Goods'
import { BASE_URL } from '../common/Config'
import { Empty } from '../components/Empty'
import { EmitterEventId, emitterUtil } from '../utils/EmitterUtil'
import { BannerItem } from '../viewmodel/BannerModel'
import { CartModel } from '../viewmodel/CartModel'
import { GoodsItem } from '../viewmodel/GoodsModel'

interface IRouterParams {
  goods_id: number
}

interface requestGoodsParams {
  id: number
}

@Entry
@Component
struct GoodsDetail {
  @State goods_id: number = 0
  @State goods: GoodsItem | undefined = undefined

  aboutToAppear(): void {
    const params = router.getParams() as IRouterParams
    this.goods_id = params?.goods_id
    if(this.goods_id) {
      this.getGoodsDetail()
    }
  }

  async getGoodsDetail() {
    const res = await requestGoodsById<GoodsItem, requestGoodsParams>({
      id: this.goods_id
    })
    this.goods = res.data.goods
  }

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
    Scroll() {
      Column() {
        Column() {
          Stack({
            alignContent: Alignment.TopStart
          }) {
            Swiper() {
              ForEach(this.goods?.banner, (banner: BannerItem) => {
                Image(BASE_URL + banner.url)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Cover)
              }, (banner: BannerItem) => `${banner.id}`)
            }
            .indicator(new DotIndicator().selectedColor($r('app.color.color_primary')))
            .height('414')
            .width('100%')
            Stack() {
              Circle()
                .width(36)
                .height(36)
                .fill('#000')
                .fillOpacity(0.4)
              Image($r('app.media.arrow_left'))
                .width(27)
                .height(27)
            }
            .margin({top: 7, left: 3})
            .onClick(() => {
              router.back()
            })
          }
        }
        .width('100%')

        Column() {
          Row() {
            Text('￥')
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.price_color_new'))
            Text(`${this.goods?.new_price}`)
              .margin({right: 5})
              .fontSize(25)
              .fontColor($r('app.color.price_color_new'))
            Text(`￥${this.goods?.old_price}`)
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color_light'))
              .decoration({type: TextDecorationType.LineThrough, color: $r('app.color.price_color_old')})
          }
          .width('100%')
          Row() {
            Text(this.goods?.desc)
              .fontWeight(FontWeight.Bold)
              .fontSize(17)
              .lineHeight(24)
          }
          .width('100%')
          .margin({top: 10, bottom: 10})
          Row() {
            Button('加入购物车')
              .controlSize(ControlSize.SMALL)
              .backgroundColor($r('app.color.bg_primary'))
              .onClick(() => {
                this.onAddToCart(this.goods as GoodsItem)
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .padding({top: 10, right: 16, bottom: 10, left: 16})
        .backgroundColor('#fff')

        Column() {
          Text('商品评价')
            .fontSize($r('app.float.font_size_large'))
            .fontColor($r('app.color.text_color'))
          Column(){
            Empty({desc: '暂无评价', icon: $r('app.media.icon_comment'), padTop: 20})
          }
        }
        .width('100%')
        .padding(16)
        .margin({top: 10, bottom: 10})
        .backgroundColor('#fff')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .backgroundColor($r('app.color.bg_color_page'))
  }
}