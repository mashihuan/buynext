@Component
export struct CartEmpty {
  text: ResourceStr = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_cart_empty'))
          .width(60)
          .height(60)
      }
      .width(110)
      .height(110)
      .justifyContent(FlexAlign.Center)
      .borderRadius(55)
      .backgroundColor($r('app.color.bg_primary'))
      Text(this.text)
        .margin({top: 16, bottom: 16})
        .fontSize($r('app.float.font_size_large'))
        .fontColor($r('app.color.text_color'))
    }
    .padding({top: 165})
  }
}