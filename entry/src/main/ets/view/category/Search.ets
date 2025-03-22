import { router } from "@kit.ArkUI"

@Component
export struct CategorySearch {
  build() {
    Row() {
      Row() {
        Image($r('app.media.icon_search'))
          .width(16)
          .height(16)
          .fillColor($r('app.color.text_color_placeholder'))
        Text('请输入')
          .margin({left: 5})
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_color_placeholder'))
      }
      .width('100%')
      .height(28)
      .padding({left: 20})
      .backgroundColor('#fff')
      .borderRadius(14)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/SearchPage'
        })
      })
    }
    .width('100%')
    .height(48)
    .padding({left: 16, right: 16})
    .backgroundColor($r('app.color.bg_primary'))
  }
}