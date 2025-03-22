import { promptAction } from "@kit.ArkUI"

@Component
export struct OrderIntegral {
  @State integral: number = 0

  build() {
    Column() {
      Row() {
        Text(`可用积分（${this.integral}）`)
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
        Image($r('app.media.icon_question'))
          .width(16)
          .onClick(() => {
            promptAction.showToast({
              message: '积分满100可用',
              alignment: Alignment.Center
            })
          })
        Blank()
        Toggle({type: ToggleType.Checkbox})
          .enabled(this.integral >= 100)
          .selectedColor($r('app.color.color_primary'))
        Text('使用')
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
      }
      .width('100%')
      Row() {
        Text('备注')
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.text_color'))
      }
      .width('100%')
      .margin({top: 10, bottom: 10})
      TextArea({placeholder: '有什么需要告诉我们的'})
        .height(82)
        .fontSize($r('app.float.font_size'))
        .fontColor($r('app.color.text_color'))
        .borderRadius(0)
    }
    .width('100%')
    .padding(16)
    .margin({top: 10})
    .backgroundColor('#fff')
  }
}