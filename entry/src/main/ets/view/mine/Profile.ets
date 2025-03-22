import { router } from "@kit.ArkUI"

@Component
export struct MineProfile {
  build() {
    Row() {
      Image($r('app.media.avatar'))
        .width(66)
        .height(66)
        .borderRadius(33)
        .margin({right: 10})
        .objectFit(ImageFit.Cover)
      Column({space: 8}) {
        Text('食屎不忘拉屎人')
          .fontSize(18)
          .fontColor('#fff')
        Row() {
          Image($r('app.media.icon_settings'))
            .width(16)
            .margin({right: 5})
          Text('个人资料')
            .fontSize(13)
            .fontColor('#fff')
        }
      }
      .margin({top: 8})
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(142)
    .padding(16)
    .alignItems(VerticalAlign.Top)
    .backgroundColor($r('app.color.bg_primary'))
    .border({color: 'rgba(255,255,255,0.3)', width: {top: 0.1}})
    .onClick(() => {
      router.pushUrl({
        url: 'pages/PersonalData'
      })
    })
  }
}