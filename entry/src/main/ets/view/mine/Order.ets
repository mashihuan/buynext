import { router } from "@kit.ArkUI"

class Params {
  index: number = 0
}

class OrderType {
  icon: ResourceStr = ''
  text: string = ''
  path: string = ''
  type?: string = ''
  params?: Params
}

@Component
export struct MineOrder {
  orderTypes: OrderType[] = [
    { text: '待付款', icon: $r('app.media.order_no_pay'), path: 'pages/OrderList', params: { index: 1 } },
    { text: '待收货', icon: $r('app.media.order_no_delivery'), path: 'pages/OrderList', params: { index: 2 } },
    { text: '待评价', icon: $r('app.media.order_no_comment'), path: 'pages/OrderList', params: { index: 3 } },
    { text: '售后/退款', icon: $r('app.media.order_after_sale'), path: 'pages/AfterSale', params: { index: 0 } },
  ]

  build() {
    Column() {
      Row() {
        Text('我的订单')
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_color'))
        Blank()
        Row() {
          Text('查看更多')
            .fontSize($r('app.float.font_size_small'))
            .fontColor($r('app.color.text_color_lighter'))
          Image($r('app.media.arrow_right'))
            .width(14)
            .fillColor($r('app.color.text_color_lighter'))
        }
        .onClick(() => {
          router.pushUrl({
            url: 'pages/OrderList',
            params: {
              index: 0
            }
          })
        })
      }
      .width('100%')

      Flex({justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center}) {
        ForEach(this.orderTypes, (orderType: OrderType) =>{
          Column({space: 10}) {
            Image(orderType.icon)
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
            Text(orderType.text)
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color_light'))
          }
          .flexGrow(1)
          .height(70)
          .justifyContent(FlexAlign.End)
          .onClick(() => {
            router.pushUrl({
              url: orderType.path,
              params: orderType.params
            })
          })
        }, (orderType: OrderType) => orderType.text)
      }
      .width('100%')
    }
    .width('100%')
    .padding(10)
    .margin({top: 10})
    .borderRadius(5)
    .backgroundColor('#fff')
  }
}