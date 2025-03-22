import { router } from "@kit.ArkUI"

@Component
export struct MineCoupon {
  @StorageProp('integral') integral: number = 0

  build() {
    Flex({alignItems: ItemAlign.Center}) {
      Flex({alignItems: ItemAlign.Center}) {
        Image($r('app.media.mine_coupon'))
          .width(27)
          .height(27)
          .margin({right: 10})
        Text('优惠券')
          .flexGrow(1)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
        Text(`0张`)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
      }
      .padding({top: 10, right: 16, bottom: 10, left: 16})
      .border({color: $r('app.color.border_color_light'), width: {right: 1}})
      .onClick(() => {
        router.pushUrl({
          url: 'pages/CouponList'
        })
      })

      Flex({alignItems: ItemAlign.Center}) {
        Image($r('app.media.mine_integral'))
          .width(27)
          .height(27)
          .margin({right: 10})
        Text('积分')
          .flexGrow(1)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
        Text(`${this.integral}分`)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
      }
      .padding({top: 10, right: 16, bottom: 10, left: 16})
      .onClick(() => {
        router.pushUrl({
          url: 'pages/IntegralPage'
        })
      })
    }
    .width('100%')
    .margin({top: -35})
    .borderRadius(5)
    .backgroundColor('#fff')
  }
}