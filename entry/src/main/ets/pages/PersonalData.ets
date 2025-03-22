import { promptAction, router } from '@kit.ArkUI'
import { NavigationBar } from '../components/NavigationBar'
import { fileUpload, photoSelect } from '../utils/FileUpload'

@Extend(Row) function rowStyle() {
  .width('100%')
  .padding({top: 20, right: 10, bottom: 20, left: 10})
  .border({width: {bottom: 1}, color: $r('app.color.border_color_light')})
}

@Extend(Text) function textStyle() {
  .fontSize($r('app.float.font_size_large'))
  .fontColor($r('app.color.text_color'))
}

@Extend(Image) function arrowStyle() {
  .width(20)
  .fillColor($r('app.color.text_color_lighter'))
}

@Entry
@Component
struct PersonalData {
  @State avatar: ResourceStr = $r('app.media.avatar')
  @State nickname: string = '食屎不忘拉屎人'
  @State phone: number = 19694775140

  async changeAvatar() {
    const uris = await photoSelect()
    if(uris.length) {
      this.avatar = uris[0]
      fileUpload(uris)
    }
  }

  build() {
    Column() {
      NavigationBar({title: '个人资料'})
      Column() {}
      .width('100%')
      .height(70)
      .backgroundColor($r('app.color.bg_primary'))

      Column() {
        Column() {
          Row() {
            Text('头像')
              .textStyle()
            Blank()
            Image(this.avatar)
              .width(55)
              .height(55)
              .borderRadius(28)
              .objectFit(ImageFit.Cover)
              .onClick(() => {
                this.changeAvatar()
              })
            Image($r('app.media.arrow_right'))
              .arrowStyle()
          }
          .rowStyle()

          Row() {
            Text('昵称')
              .textStyle()
            Blank()
            TextInput({text: $$this.nickname})
              .width('auto')
              .padding(0)
              .fontSize($r('app.float.font_size_large'))
              .fontColor($r('app.color.text_color'))
              .backgroundColor('transparent')
              .onBlur(() => {
                promptAction.showToast({message: '昵称修改成功'})
              })
            Image($r('app.media.arrow_right'))
              .arrowStyle()
          }
          .rowStyle()

          Row() {
            Text('手机号')
              .textStyle()
            Blank()
            Text(`${this.phone}`)
              .textStyle()
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ChangePhone'
                })
              })
            Image($r('app.media.arrow_right'))
              .arrowStyle()
          }
          .rowStyle()
        }
        .width('100%')
        .padding({right: 5, left: 5})
        .borderRadius(5)
        .backgroundColor('#fff')
      }
      .width('100%')
      .padding({right: 16, left: 16})
      .margin({top: -45})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}