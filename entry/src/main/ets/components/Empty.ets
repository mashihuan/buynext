@Component
export struct Empty {
  icon: ResourceStr = $r('app.media.icon_empty')
  iconSize: number = 55
  padTop: number = 82
  desc: ResourceStr = '暂无数据...'

  build() {
    Column({space: 10}) {
      Image(this.icon)
        .width(this.iconSize)
        .fillColor($r('app.color.text_color_lighter'))
      Text(this.desc)
        .fontSize($r('app.float.font_size'))
        .fontColor($r('app.color.text_color_lighter'))
    }
    .width('100%')
    .padding({top: this.padTop})
  }
}