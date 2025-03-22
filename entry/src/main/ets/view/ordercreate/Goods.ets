import { BASE_URL } from "../../common/Config"
import { CartItem } from "../../viewmodel/CartModel"

@Component
export struct OrderGoods {
  @StorageProp('cartList') cartList: CartItem[] = []

  build() {
    Column() {
      ForEach(this.cartList, (cart: CartItem) => {
        Row() {
          Image(BASE_URL + cart.goods.icon)
            .width(82)
            .height(82)
            .margin({right: 10})
            .objectFit(ImageFit.Cover)
          Column({space: 10}) {
            Row() {
              Text(cart.goods.desc)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
            }
            .width('100%')
            Row() {
              Text(`￥${(cart.goods.new_price * cart.num).toFixed(1)}`)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.price_color_new'))
              Text(`x${cart.num}`)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color_light'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding(16)
      }, (cart: CartItem) => `${cart.id}`)
    }
    .width('100%')
    .margin({top: 10})
    .backgroundColor('#fff')
  }
}