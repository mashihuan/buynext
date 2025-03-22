import { BASE_URL } from "../../common/Config"
import { CategoryTitle } from "../../components/CategoryTitle"
import { MenuItem } from "../../viewmodel/MenuModel"
import { router } from "@kit.ArkUI"

@Component
export struct MenuList {
  @Link menuList: MenuItem[]

  build() {
    Column() {
      CategoryTitle({title: '今日菜单'})
      List({space: 10}) {
        ForEach(this.menuList, (menu: MenuItem) => {
          ListItem() {
            Column({space: 10}) {
              Image(BASE_URL + menu.img)
                .width('100%')
                .height(132)
                .objectFit(ImageFit.Cover)
              Text(menu.name)
                .fontSize($r('app.float.font_size'))
                .fontColor($r('app.color.text_color'))
            }
            .onClick(() => {
              router.pushUrl({
                url: 'pages/MenuDetail',
                params: {
                  menu_id: menu.id
                }
              })
            })
          }
          .width('96%')
        }, (menu: MenuItem) => menu.id + '')
      }
      .lanes(2)
    }
    .width('100%')
    .padding(10)
    // .margin({top: 10})
    .backgroundColor('#fff')
  }
}