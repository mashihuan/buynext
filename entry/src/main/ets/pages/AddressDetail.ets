import { NavigationBar } from '../components/NavigationBar';
import { cityData } from '../common/city.data'
import { AddressItem, AddressModel } from '../viewmodel/AddressModel';
import { promptAction, router } from '@kit.ArkUI';

@Extend(Row) function rowStyle() {
  .width('100%')
  .padding(16)
  .border({width: {bottom: 1}, color: $r('app.color.border_color_light')})
}

@Extend(Text) function labelStyle() {
  .width(71)
  .fontSize(15)
  .fontColor($r('app.color.text_color_light'))
}

@Extend(TextInput) function inputStyle() {
  .placeholderFont({size: 15})
  .fontSize(15)
  .backgroundColor('transparent')
  .layoutWeight(1)
}

class DataModel {
  id: number = 0
}

@Entry
@Component
struct AddressDetail {
  @State title: string = '新增地址';
  @State name: string = ''
  @State phone: string = ''
  @State area: string = ''
  @State detail: string = ''
  @State is_default: boolean = false
  @State addressId: number = 0

  @State areaSelected: number | number[] = []

  aboutToAppear(): void {
    const params: DataModel = router.getParams() as DataModel
    this.addressId = params?.id
    if(this.addressId) {
      this.getAddressDetail()
      this.title = '编辑地址'
    }
  }

  async getAddressDetail() {
    const res = await AddressModel.get(this.addressId)
    const detail = res[0]
    if(detail) {
      this.name = detail.name
      this.phone = detail.phone
      this.area = detail.area
      this.detail = detail.detail
      this.is_default = detail.is_default ? true : false
    }
  }

  async selectArea() {
    this.getUIContext().showTextPickerDialog({
      range: cityData,
      selected: this.areaSelected,
      textStyle: {color: $r('app.color.text_color'), font: {size: 20, weight: FontWeight.Normal}},
      selectedTextStyle: {color: $r('app.color.color_primary'), font: {size: 20, weight: FontWeight.Bolder}},
      onAccept: (value: TextPickerResult) => {
        // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
        this.areaSelected = value.index
        // 点击确定后，被选到的文本数据展示到页面
        this.area = (value.value as string[]).join('')
        // console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
      }
    })
  }

  async save() {
    const flag = this.is_default ? 1 : 0
    if(flag) {
      const res = await AddressModel.getByIsDefault(flag)
      if(res.length) {
        const data = res[0]
        await AddressModel.update({
          id: data.id,
          is_default: 0
        })
      }
    }
    if(this.addressId) {
      await AddressModel.update({
        id: this.addressId,
        name: this.name,
        phone: this.phone,
        area: this.area,
        detail: this.detail,
        is_default: flag
      })
    }else {
      await AddressModel.insert({
        name: this.name,
        phone: this.phone,
        area: this.area,
        detail: this.detail,
        is_default: flag
      })
    }

    promptAction.showToast({message: '保存成功'})
    router.back()
  }

  async delete() {
    this.getUIContext().showAlertDialog({
      title: '提示',
      message: '确定要删除该数据吗？',
      buttons: [
        {
          value: '取消',
          action: () => {}
        },
        {
          value: '删除',
          action: async () => {
            await AddressModel.delete(this.addressId)
            promptAction.showToast({message: '删除成功'})
            router.back()
          }
        }
      ]
    })
  }

  build() {
    Column() {
      NavigationBar({title: this.title})
      Column() {
        Row() {
          Text('收货人')
            .labelStyle()
          TextInput({placeholder: '姓名', text: $$this.name})
            .inputStyle()
        }
        .rowStyle()

        Row() {
          Text('联系方式')
            .labelStyle()
          TextInput({placeholder: '手机号码', text: $$this.phone})
            .inputStyle()
        }
        .rowStyle()

        Row() {
          Text('所在地区')
            .labelStyle()
          TextInput({placeholder: '选择地区', text: $$this.area})
            .inputStyle()
            .onClick(() => {
              this.selectArea()
            })
          Image($r('app.media.arrow_right'))
            .width(16)
            .fillColor($r('app.color.text_color_lighter'))
        }
        .rowStyle()

        Row() {
          Text('详细地址')
            .labelStyle()
          TextArea({placeholder: '详细地址', text: $$this.detail})
            .placeholderFont({size: 15})
            .fontSize(15)
            .backgroundColor('transparent')
            .layoutWeight(1)
        }
        .rowStyle()

        Row() {
          Text('设为默认地址')
            .labelStyle()
            .width('auto')
          Toggle({type: ToggleType.Switch, isOn: $$this.is_default})
            .selectedColor($r('app.color.color_primary'))
        }
        .rowStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .border({width: 0})

        Column({space: 12}) {
          Button('确定')
            .width('100%')
            .backgroundColor($r('app.color.bg_primary'))
            .onClick(() => {
              this.save()
            })
          Button('删除收货地址')
            .width('100%')
            .backgroundColor('#fff')
            .fontColor($r('app.color.text_color'))
            .border({color: $r('app.color.border_color'), width: 1})
            .enabled(!!this.addressId)
            .onClick(() => {
              this.delete()
            })
        }
        .width('100%')
        .padding({right: 16, left: 16})
        .margin({top: 12})
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#fff')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}