import { BASE_URL } from "../../common/Config"
import { CartItem, CartModel } from "../../viewmodel/CartModel"

@Component
export struct CartListItem {
  @ObjectLink cart: CartItem
  @Prop selectedIds: number[] = []
  handlePriceAndNumber: () => void = () => {}

  build() {
    Row() {
      Checkbox({group: 'cart', name: `${this.cart.id}`})
        .select(this.selectedIds.includes(this.cart.id))
        .selectedColor($r('app.color.bg_primary'))
      Image(BASE_URL + this.cart.goods.icon)
        .width(100)
        .height(100)
        .margin({right: 16, left: 16})
        .objectFit(ImageFit.Cover)
        .borderRadius(55)
      Column() {
        Text(this.cart.goods.name)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
        Row() {
          Text(`￥${this.cart.goods.new_price}`)
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.price_color_new'))
          Counter() {
            Text(this.cart.num.toString())
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color'))
          }
          .enableDec(this.cart.num > 1)
          .onInc(async () => {
            this.cart.num += 1
            await CartModel.update({
              id: this.cart.id,
              num: this.cart.num
            })
            this.handlePriceAndNumber()
          })
          .onDec(async () => {
            this.cart.num -= 1
            await CartModel.update({
              id: this.cart.id,
              num: this.cart.num
            })
            this.handlePriceAndNumber()
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .height(100)
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(10)
    .backgroundColor('#fff')
    .borderRadius(5)
  }
}