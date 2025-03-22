import { NavigationBar } from '../components/NavigationBar'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Feedback {
  @State content: string = ''

  build() {
    Column() {
      NavigationBar({title: '意见反馈'})
      TextArea({text: $$this.content, placeholder: '我们想听听你的心声,如果愿意,你也可以留下联系方式,我们期待与您的真诚沟通.'})
        .height(220)
        .borderRadius(0)
        .fontSize($r('app.float.font_size_large'))
        .fontColor($r('app.color.text_color'))
        .lineHeight(24)
        .backgroundColor('#fff')
      Button('提交', { type: ButtonType.Normal })
        .width('86%')
        .position({bottom: '10%', right: '7%', left: '7%'})
        .backgroundColor($r('app.color.bg_primary'))
        .borderRadius(5)
        .onClick(() => {
          promptAction.showToast({message: '点击了提交'})
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}