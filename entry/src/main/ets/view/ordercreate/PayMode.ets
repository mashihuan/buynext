type IMode = 'wechat' | 'ali'

class PayMode {
  name: string = ''
  icon: ResourceStr = ''
  mode: IMode | undefined = undefined
}

@Component
export struct OrderPayMode {
  @Link payMode: string
  payModes: PayMode[] = [
    { name: '微信支付', icon: $r('app.media.wechat'), mode: 'wechat' },
    { name: '支付宝支付', icon: $r('app.media.ali'), mode: 'ali' },
  ]

  build() {
    Column({space: 20}) {
      Row() {
        Text('支付方式')
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_color'))
      }
      .width('100%')
      ForEach(this.payModes, (mode: PayMode) => {
        Row() {
          Image(mode.icon)
            .width(33)
            .height(33)
            .margin({right: 16})
          Text(mode.name)
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color'))
          Blank()
          Radio({
            group: 'pay',
            value: mode.mode
          })
            .onChange((isChecked) => {
              if(isChecked) {
                this.payMode = mode.mode as string
              }
            })
            .radioStyle({
              checkedBackgroundColor: $r('app.color.color_primary')
            })
        }
        .width('100%')
      }, (mode: PayMode) => mode.name)
    }
    .width('100%')
    .padding(16)
    .margin({top: 10})
    .backgroundColor('#fff')
  }
}