import { NavigationBar } from '../components/NavigationBar'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Invite {

  build() {
    Column() {
      NavigationBar({title: '邀请有礼'})
      Image($r('app.media.invite_banner'))
        .width('100%')
        .height(115)

      Button('立即邀请微信好友', { type: ButtonType.Normal })
        .width('86%')
        .position({bottom: '10%', right: '7%', left: '7%'})
        .backgroundColor($r('app.color.bg_primary'))
        .borderRadius(5)
        .onClick(() => {
          this.getUIContext().showActionSheet({
            title: '',
            message: '',
            sheets: [
              {
                title: '分享到聊天',
                action: () => {
                  console.log('分享到聊天')
                  promptAction.showToast({message: '分享到聊天'})
                }
              },
              {
                title: '分享到朋友圈',
                action: () => {
                  console.log('分享到朋友圈')
                  promptAction.showToast({message: '分享到朋友圈'})
                }
              }
            ],
            confirm: {
              defaultFocus: true,
              value: '取消',
              action: () => {
                console.log('Get Alert Dialog handled')
              }
            }
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}