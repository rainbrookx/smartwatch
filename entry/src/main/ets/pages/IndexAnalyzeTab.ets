import StepStatisticsPage from './Fyx2StepStatistics'
import SleepStatisticsPage from './Lmy2SleepStatistics'
// import HeartRatePage from './Whw1HeartRatePage'
// import TodoPage from './Whw2TodoPage'

@Entry
@Component
struct IndexAnalyzeTab {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          StepStatisticsPage()
        }.tabBar(this.tabBuilder(0, '记步'))

        TabContent() {
          SleepStatisticsPage()
        }.tabBar(this.tabBuilder(1, '睡眠'))

        TabContent() {
          // HeartRatePage()
        }.tabBar(this.tabBuilder(2, '心率'))

        TabContent() {
          // TodoPage()
        }.tabBar(this.tabBuilder(3, '日程'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(360)
      .barHeight(56)
      .animationDuration(400)
      .onChange((index: number) => {
        // currentIndex控制TabContent显示页签
        this.currentIndex = index
        this.selectedIndex = index
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return
        }
        this.selectedIndex = targetIndex
      })
      .width(360)
      .height('90%')
      .margin({ top: 52 })
      .backgroundColor('#F1F3F5')
    }.width('100%')
  }
}