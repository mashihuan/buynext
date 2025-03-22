@Component
export struct CategoryTitle {
  title: ResourceStr = ''

  build() {
    Row({space: 30}) {
      Divider()
        .width(66)
        .color($r('app.color.text_color_light'))
      Text(this.title)
        .fontSize(17)
        .fontColor($r('app.color.text_color'))
      Divider()
        .width(66)
        .color($r('app.color.text_color_light'))
    }
    .margin({bottom: 12})
  }
}