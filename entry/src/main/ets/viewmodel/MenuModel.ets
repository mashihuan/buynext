export class MenuFoodsItem {
  id: number = 0
  label: string = ''
  value: string = ''
  menu_id: number = 0
}

export class MenuStepsItem {
  id: number = 0
  img: string = ''
  desc: string = ''
  menu_id: number = 0
}

export class MenuItem {
  id: number = 0
  name: string = ''
  desc: string = ''
  img: string = ''
  foods?: MenuFoodsItem[]
  steps?: MenuStepsItem[]
}