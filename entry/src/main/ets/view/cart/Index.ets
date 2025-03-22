import { NavigationBar } from "../../components/NavigationBar"
import { EmitterEventId, emitterUtil } from "../../utils/EmitterUtil"
import { CartItem, CartModel } from "../../viewmodel/CartModel"
import { GoodsItem, GoodsModel } from "../../viewmodel/GoodsModel"
import { CartEmpty } from "./Empty"
import { CartListItem } from "./Item"
import { promptAction, router } from "@kit.ArkUI"

@Component
export struct CartIndex {
  @State isLogin: boolean = true
  @State isEdit: boolean = false
  @State @Watch('handlePriceAndNumber') selectedIds: number[] = []
  @State totalPrice: number = 0
  @State totalNumber: number = 0
  @State cartList: CartItem[] = [
    // new CartItem(1, 1, 1, {id: 1, name: '西红柿', desc: '西红柿', icon: $r('app.media.avatar'),new_price: 9.9, old_price: 19.9,category_id:1}),
    // new CartItem(2, 2, 3, {id: 1, name: '黄油桃', desc: '黄油桃', icon: $r('app.media.avatar'),new_price: 9.9, old_price: 19.9,category_id:1}),
  ]

  aboutToAppear(): void {
    emitterUtil.on({eventId: EmitterEventId.ADD_TO_CART}, () => {
      this.getCartList()
    })
    emitterUtil.on({eventId: EmitterEventId.CART_TO_ORDER}, () => {
      this.getCartList()
    })
    this.getCartList()
  }

  async getCartList() {
    const tempArr: CartItem[] = []
    const carts = await CartModel.query()
    const goodsList = await GoodsModel.query()
    carts.forEach((cart: CartItem) => {
      const goods = goodsList.find((goods: GoodsItem) => goods.id === cart.goods_id)
      if(goods) {
        cart.goods = goods
      }
      tempArr.push(new CartItem(cart.id, cart.goods_id, cart.num, cart.goods))
    })
    this.cartList = tempArr
  }

  handlePriceAndNumber() {
    // console.log(JSON.stringify(this.selectedIds))
    const selectedCarts = this.cartList.filter((cart:CartItem) => this.selectedIds.includes(cart.id))
    this.totalNumber = selectedCarts.reduce((prev, current) => {
      return prev + current.num
    }, 0)
    this.totalPrice = selectedCarts.reduce((prev, current) => {
      return prev + current.num * current.goods.new_price
    }, 0)
  }

  async handleDeleteCart() {
    if(!this.selectedIds.length) {
      return promptAction.showToast({message: '请选择商品'})
    }
    await CartModel.deleteList(this.selectedIds)
    this.cartList = this.cartList.filter((cart: CartItem) => !this.selectedIds.includes(cart.id))
    // await this.getCartList()
    promptAction.showToast({message: '删除成功'})
    this.selectedIds = []
  }

  @Builder deleteBuilder(id: number) {
    Button({type: ButtonType.Circle}) {
      Image($r('app.media.icon_delete'))
        .width(20)
        .fillColor('#fff')
    }
    .padding(8)
    .margin({left: 5})
    .backgroundColor($r('app.color.color_danger'))
    .onClick(async () => {
      await CartModel.delete(id)
      // this.cartList.splice(index, 1)
      this.cartList = this.cartList.filter((cart: CartItem) => cart.id !== id)
      promptAction.showToast({message: '删除成功'})
    })
  }

  build() {
    Column() {
      NavigationBar({title: '购物车', hiddenBack: true})
      if(this.isLogin) {
        if(this.cartList.length) {
          Column() {
            Row() {
              Text(this.isEdit ? '完成' : '管理')
                .fontSize(15)
                .fontColor($r('app.color.text_color'))
                .onClick(async () => {
                  this.isEdit = !this.isEdit
                })
            }
            .width('100%')
            .height(36)
            .padding(8)
            .justifyContent(FlexAlign.End)
            .backgroundColor('#fff')
            List({space: 10}) {
              ForEach(this.cartList, (cart: CartItem) => {
                ListItem() {
                  CartListItem({ cart: cart, selectedIds: this.selectedIds, handlePriceAndNumber: () => this.handlePriceAndNumber })
                }
                .swipeAction({
                  end: this.deleteBuilder(cart.id)
                })
              })
              //, (cart: CartItem) => `${cart.id}`
            }
            .width('100%')
            .height('100%')
            .layoutWeight(1)
            .padding(12)
            Row() {
              Row() {
                CheckboxGroup({group: 'cart'})
                  // .selectAll(this.selectedIds.length === this.cartList.length)
                  .selectedColor($r('app.color.color_primary'))
                  .onChange((options) => {
                    // console.log(JSON.stringify(options))
                    this.selectedIds = options.name.map((id) => parseInt(id))
                  })
                Text('全选').fontSize($r('app.float.font_size')).fontColor($r('app.color.text_color'))
              }
              Blank()
              if(!this.isEdit) {
                Row(){
                  Text('合计：')
                    .fontSize($r('app.float.font_size'))
                    .fontColor($r('app.color.text_color'))
                  Text(`￥${this.totalPrice.toFixed(1)}`)
                    .fontSize($r('app.float.font_size'))
                    .fontColor($r('app.color.price_color_new'))
                }
                Button(`结算(${this.totalNumber})件`)
                  .enabled(this.totalNumber > 0)
                  .controlSize(ControlSize.SMALL)
                  .margin({left: 22})
                  .fontSize($r('app.float.font_size'))
                  .backgroundColor($r('app.color.bg_primary'))
                  .onClick(() => {
                    const selectedCartList = this.cartList.filter((cart: CartItem) => {
                      return this.selectedIds.includes(cart.id)
                    })
                    AppStorage.setOrCreate('cartList', selectedCartList)
                    router.pushUrl({
                      url: 'pages/OrderCreate'
                    })
                  })
              }else {
                Button(`删除`)
                  .controlSize(ControlSize.SMALL)
                  .width(60)
                  .margin({left: 22})
                  .fontSize($r('app.float.font_size'))
                  .backgroundColor($r('app.color.color_danger'))
                  .onClick(() => {
                    this.handleDeleteCart()
                  })
              }
            }
            .width('100%')
            .height(55)
            .padding({right: 16, left: 16})
            .backgroundColor('#fff')
          }
          .padding({bottom: $r('app.float.navigation_bar_height')})
          .width('100%')
          .height('100%')
        }else {
          CartEmpty({text: '购物车空空如也,去逛逛吧~'})
        }
      }else {
        Column() {
          CartEmpty({text: '登录同步购物车商品'})
          Button('登录', {type: ButtonType.Normal})
            .backgroundColor($r('app.color.bg_primary'))
            .borderRadius(5)
            .onClick(() => this.isLogin = true)
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}