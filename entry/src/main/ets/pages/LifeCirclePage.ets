import { Header } from '../componts/CommonComponts'

@Entry
@Component
struct LifeCircle {
  @State show: boolean = false
  @State arr: string[] = []


  tag: string = 'Life Circle Page'

  //组件创建后，build函数执行前触发aboutToAppear；可做数据初始化供build()使用
  aboutToAppear(){
    console.log(this.tag, 'about to appear')
  }

  //页面展示
  onPageShow(){
    console.log(this.tag, 'on page show')
  }

  onBackPress(){
    console.log(this.tag, 'on back press')
  }

  //页面隐藏
  onPageHide(){
    console.log(this.tag, 'on page hide')
  }

  //组件销毁。点击系统返回键，栈顶页面会被销毁，就会触发aboutToDisappear；可做数据保存，资源释放等操作
  aboutToDisappear(){
    console.log(this.tag, 'about to disappear')
  }

  build() {
    Column({space: 20}) {
      // 顶部标题
      Header({ title: '测试组件生命周期' })

      // 按钮
      Button('切换显示')
        .onClick(() => this.show = !this.show)

      Row(){
        if(this.show){
          MyText({message: 'Hello World!'})
        }
      }
      .height(30)

      // 新增按钮
      Button('新增数据')
        .onClick(() => this.arr.push('user_' + this.arr.length))
      ForEach(this.arr, (item, index) => {
        //由于@State arr，arr变化会触发渲染UI，MyText就会多绘制一个
        MyText({message: item, index: index, delete: this.delete.bind(this)})
      })   //todo 添加ForEach第三个参数唯一标识，MyText被删除就不会全部重新渲染
    }
    .width('100%')
    .height('100%')
  }

  delete(index: number = -1){
    if(index > -1){
      this.arr.splice(index, 1)
    }
  }
}

@Component
struct MyText {
  message: string
  index?: number
  delete?: (index: number) => void


  tag: string = 'MyText Page'

  /**
   * 观察子组件生命周期的触发，子组件不会调用onPageShow、onBackPress、onPageHide这些生命周期钩子函数
   */
  aboutToAppear(){
    console.log(this.tag, 'about to appear')
  }

  onPageShow(){
    console.log(this.tag, 'on page show')
  }

  onBackPress(){
    console.log(this.tag, 'on back press')
  }

  onPageHide(){
    console.log(this.tag, 'on page hide')
  }

  //组件销毁
  aboutToDisappear(){
    console.log(this.tag, 'about to disappear')
  }


  build() {
    Row(){
      Text(this.message)
        .fontSize(20)
      if(this.delete){
        Image($r('app.media.ic_public_delete'))
          .width(20)
          .onClick(() => this.delete(this.index))
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }
}