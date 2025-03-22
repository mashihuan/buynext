import { NavigationBar } from '../components/NavigationBar'
import { OrderAddress } from '../view/ordercreate/Address'
import { OrderGoods } from '../view/ordercreate/Goods'
import { OrderIntegral } from '../view/ordercreate/Integral'
import { OrderPayMode } from '../view/ordercreate/PayMode'
import { AddressItem, AddressModel } from '../viewmodel/AddressModel'
import { CartItem, CartModel } from '../viewmodel/CartModel'
import { promptAction, router } from '@kit.ArkUI'
import { OrderGoodsModel, OrderModel } from '../viewmodel/Index'
import { OrderStatus } from '../viewmodel/OrderModel'
import { IOrderGoodsAdd } from '../viewmodel/OrderGoodsModel'
import { EmitterEventId, emitterUtil } from '../utils/EmitterUtil'

@Entry
@Component
struct OrderCreate {
  @StorageProp('cartList') cartList: CartItem[] = []
  @StorageProp('selectAddress') selectAddress: AddressItem | undefined = undefined
  @State addressList: AddressItem[] = []
  @State defaultAddress: AddressItem | undefined = undefined
  @State address_id: number = 0
  @State totalPrice: number = 0
  @State totalNumber: number = 0
  @State payMode: string = ''

  onPageShow(): void {
    this.handlePriceAndNumber()
    this.getAddressList()
  }

  handlePriceAndNumber() {
    this.totalNumber = this.cartList.reduce((prev, current) => {
      return prev + current.num
    }, 0)
    this.totalPrice = this.cartList.reduce((prev, current) => {
      return prev + current.num * current.goods.new_price
    }, 0)
  }

  async getAddressList() {
    const res = await AddressModel.query()
    const data = res || []
    this.addressList = data
    this.defaultAddress = this.addressList.find((address: AddressItem) => address.is_default)
  }

  async submit() {
    if(!this.address_id) {
      return promptAction.showToast({message: '请选择收货地址'})
    }
    if(!this.payMode) {
      return promptAction.showToast({message: '请选择支付方式'})
    }
    // 创建order业务表
    const order_id = await OrderModel.insert({
      address_id: this.address_id,
      status: OrderStatus.NO_PAY
    })
    // 创建order_goods关系表（存储订单商品信息）
    await OrderGoodsModel.batchInsert(this.cartList.map((cart: CartItem) => {
      return {
        order_id: order_id,
        goods_id: cart.goods_id,
        num: cart.num,
        price: Number((cart.goods.new_price * cart.num).toFixed(1))
      } as IOrderGoodsAdd
    }))
    // 删除确认订单里的购物车
    await CartModel.deleteList(this.cartList.map((cart: CartItem) => cart.id))
    // 发射事件，通知购物车重新拉取请求
    emitterUtil.emit({eventId: EmitterEventId.CART_TO_ORDER})
    // 未对接支付，此处直接走失败
    router.replaceUrl({
      url: 'pages/PayFail'
    })
  }

  build() {
     Column() {
       NavigationBar({title: '确认订单'})
       Column() {
         Scroll() {
           Column() {
             OrderAddress({defaultAddress: this.defaultAddress || this.selectAddress, address_id: this.address_id})
             OrderGoods()
             OrderIntegral()
             OrderPayMode({payMode: this.payMode})
           }
           .alignSelf(ItemAlign.Start)
         }
       }
       .layoutWeight(1)
       .padding({bottom: 70})
       Row({space: 16}) {
         Text(`共${this.totalNumber}件`)
           .fontSize($r('app.float.font_size'))
           .fontColor($r('app.color.text_color_light'))
         Row() {
           Text(`合计：`)
             .fontSize($r('app.float.font_size'))
             .fontColor($r('app.color.text_color'))
           Text(`￥${this.totalPrice.toFixed(1)}`)
             .fontSize($r('app.float.font_size'))
             .fontColor($r('app.color.price_color_new'))
         }
         Button('提交订单')
           .backgroundColor($r('app.color.color_primary'))
           .controlSize(ControlSize.SMALL)
           .onClick(() => {
             this.submit()
           })
       }
       .position({bottom: 0})
       .width('100%')
       .padding(16)
       .justifyContent(FlexAlign.End)
       .backgroundColor('#fff')
     }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}