import { promptAction, router } from '@kit.ArkUI'
import { requestMenuById } from '../api/Menu'
import { BASE_URL } from '../common/Config'
import { MenuFoodsItem, MenuItem, MenuStepsItem } from '../viewmodel/MenuModel'

interface IRouterParams {
  menu_id: number
}

interface requestMenuParams {
  id: number
}

@Entry
@Component
struct GoodsDetail {
  @State menu_id: number = 0
  @State menu: MenuItem | undefined = undefined

  aboutToAppear(): void {
    const params = router.getParams() as IRouterParams
    this.menu_id = params?.menu_id
    if(this.menu_id) {
      this.getMenuDetail()
    }
  }

  async getMenuDetail() {
    const res = await requestMenuById<MenuItem, requestMenuParams>({
      id: this.menu_id
    })
    this.menu = res.data.menu
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Stack({
            alignContent: Alignment.TopStart
          }) {
            Image(BASE_URL + this.menu?.img)
              .width('100%')
              .height(230)
              .objectFit(ImageFit.Cover)
            Stack() {
              Circle()
                .width(36)
                .height(36)
                .fill('#000')
                .fillOpacity(0.4)
              Image($r('app.media.arrow_left'))
                .width(27)
                .height(27)
            }
            .margin({top: 7, left: 3})
            .onClick(() => {
              router.back()
            })
          }
        }
        .width('100%')

        Column() {
          Row() {
            Text(this.menu?.desc)
              .fontSize(17)
              .lineHeight(24)
          }
          .width('100%')
          Row() {
            Text(this.menu?.name)
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_color'))
            Button('立即分享')
              .controlSize(ControlSize.SMALL)
              .backgroundColor($r('app.color.bg_primary'))
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
          .width('100%')
          .padding(16)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .padding(5)
        .backgroundColor('#fff')

        Column({space: 18}) {
          Text('食材清单')
            .fontSize(17)
            .fontColor($r('app.color.text_color'))
          Column({space: 18}){
            ForEach(this.menu?.foods, (food: MenuFoodsItem) => {
              Row() {
                Text(food.label)
                  .fontSize(15)
                  .fontColor($r('app.color.text_color'))
                Text(food.value)
                  .fontSize(15)
                  .fontColor($r('app.color.text_color'))
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }, (food: MenuFoodsItem) => `${food.id}`)
          }
        }
        .width('100%')
        .padding(16)
        .margin({top: 10, bottom: 10})
        .backgroundColor('#fff')
        .alignItems(HorizontalAlign.Start)

        Column({space: 18}) {
          Text('烹饪步骤')
            .fontSize(17)
            .fontColor($r('app.color.text_color'))
          Column({space: 18}){
            ForEach(this.menu?.steps, (step: MenuStepsItem, index: number) => {
              Row() {
                Text(`步骤${index+1}/${this.menu?.steps?.length}`)
                  .fontSize(15)
                  .fontColor($r('app.color.text_color'))
              }
              .width('100%')
              Image(BASE_URL + step.img)
                .width('100%')
                .height(198)
                .borderRadius(8)
              Row() {
                Text(step.desc)
                  .fontSize(15)
                  .fontColor($r('app.color.text_color'))
              }
              .width('100%')
            }, (step: MenuStepsItem) => `${step.id}`)
          }
        }
        .width('100%')
        .padding(16)
        .margin({top: 10, bottom: 10})
        .backgroundColor('#fff')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .backgroundColor($r('app.color.bg_color_page'))
  }
}