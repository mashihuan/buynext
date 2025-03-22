import { AddressItem } from "../../viewmodel/AddressModel"
import { router } from "@kit.ArkUI"

@Component
export struct OrderAddress {
  @Prop @Watch('setAddressId') defaultAddress: AddressItem
  @Link address_id: number

  setAddressId() {
    this.address_id = this.defaultAddress.id
  }

  build() {
    Column() {
      Column() {
        Row() {
          if(!this.defaultAddress) {
            Image($r('app.media.icon_add'))
              .width(22)
              .margin({right: 16})
            Text('添加收货地址')
              .fontSize($r('app.float.font_size'))
              .fontColor($r('app.color.text_color'))
              .layoutWeight(1)

          }else {
            Row() {
              Column({space: 10}) {
                Row({space: 10}) {
                  Text(this.defaultAddress.name)
                    .fontSize($r('app.float.font_size_large'))
                    .fontColor($r('app.color.text_color'))
                  Text(this.defaultAddress.phone)
                    .fontSize($r('app.float.font_size'))
                    .fontColor($r('app.color.text_color_light'))
                }
                .width('100%')
                Text(this.defaultAddress.area + ' ' + this.defaultAddress.detail)
                  .fontSize($r('app.float.font_size'))
                  .fontColor($r('app.color.text_color_light'))
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .layoutWeight(1)
          }
          Image($r('app.media.arrow_right'))
            .width(16)
            .fillColor($r('app.color.text_color_lighter'))
        }
        .width('100%')
        .padding({top: 10, right: 16, bottom: 10, left: 16})
        Image($r('app.media.icon_border'))
          .width('100%')
          .height(2)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor('#fff')
    .onClick(() => {
      router.pushUrl({
        url: 'pages/Address',
        params: {
          from: 'pages/OrderCreate'
        }
      })
    })
  }
}