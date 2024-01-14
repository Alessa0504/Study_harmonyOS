//任务类
class Task {
  static id: number = 1 //static表示无论创建多少个Task对象，共享这个变量
  // 任务名称
  name: string = `任务${Task.id++}`
  // 任务状态：是否完成
  finished: boolean = false
}

// 统一的卡片样式
@Styles function card() {
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
}

class StatInfo {
  //总任务数量
   totalTask: number = 0
  //已完成任务数量
   finishTask: number = 0
}

@Entry
@Component
struct ProPage {   //父组件
  // //总任务数量
  // @State totalTask: number = 0
  // //已完成任务数量
  // @State finishTask: number = 0
  //统计信息
  @State statInfo: StatInfo = new StatInfo()

  build() {
    Column({ space: 10 }) {
      // 1.任务进度卡片
      TaskStatistics({totalTask: this.statInfo.totalTask, finishTask: this.statInfo.finishTask})

      // 2.新增任务按钮
      TaskList({statInfo: $statInfo})  //$totalTask表示传递的是totalTask的引用
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')
  }
}


@Component
struct TaskStatistics {    //子组件
  //总任务数量
  @Prop totalTask: number   //子组件只能定义成StatInfo里面的变量
  //已完成任务数量
  @Prop finishTask: number

  // @Prop statInfo: StatInfo    //@Prop不可以传递对象

  build() {
    Row() {
      Text('任务进度：')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Stack() { //堆叠容器, 详见右侧API Reference
        Progress({
          value: this.finishTask,
          total: this.totalTask,
          type: ProgressType.Ring //环形
        })
          .width(100)
        Row() {
          Text(this.finishTask.toString())
            .fontSize(24)
            .fontColor('#36D')
          Text(' / ' + this.totalTask.toString())
            .fontSize(24)
        }
      }
    }
    .card()
    .margin({ top: 20, bottom: 10 })
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}

@Component
struct TaskList {
  // //总任务数量
  // @Link totalTask: number
  // //已完成任务数量
  // @Link finishTask: number

  @Link statInfo: StatInfo    //@Link可以传递对象
  //任务数组
  @State tasks: Task[] = []

  build() {
    Column() {   //子组件只能有一个根组件
      Button('新增任务')
        .width(200)
        .onClick(() => {
          // 1.新增任务数数据
          this.tasks.push(new Task())  //new Task()不用传参因为参数有默认值
          // 2.更新任务总数量
          this.handlerTaskChange()
        })

      // 3.任务列表
      List({space: 10}) {
        ForEach(
          this.tasks,
          (item: Task, index?: number) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontSize(20)
                Checkbox()
                  .select(item.finished)
                  .onChange((value: boolean) => {
                    // 1.更新当前任务状态
                    item.finished = value
                    // 2.更新已完成任务数量
                    this.handlerTaskChange()
                  })
              }
              .card()   //卡片效果
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .swipeAction({end: this.DeleteButton(index)})
          }
        )
      }
      .width('100%')
      .alignListItem(ListItemAlign.Center)   //List内部元素布局
      .layoutWeight(1)   //剩余高度都给List
    }

  }

  handlerTaskChange() {
    // 1.更新任务总数量
    this.statInfo.totalTask = this.tasks.length
    // 2.更新已完成任务数量
    this.statInfo.finishTask = this.tasks.filter(item => item.finished)  //item.finished作为filter的返回值表示item.finished为true时过滤器保留该item
      .length
  }

  //删除按钮
  @Builder DeleteButton(index: number) {    //构建函数function可省略
    Button() {
      Image($r('app.media.ic_public_delete_filled'))
        .fillColor(Color.White)
        .width(20)
    }
    .width(40)
    .height(40)
    .type(ButtonType.Circle)
    .backgroundColor(Color.Red)
    .margin(5)
    .onClick(() => {
      this.tasks.splice(index, 1)
      this.handlerTaskChange()
    })
  }
}