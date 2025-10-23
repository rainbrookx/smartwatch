import { StepData, StepResponse } from '../typing'
import { getStepList } from '../http/fyx_request'

@Entry
@Component
export default struct StepStatistics {
  @State stepData: StepData[] = []
  @State totalSteps: number = 46030
  @State averageSteps: number = 0
  @State dateRange: string = '2018.10.06-2018.10.13'

  aboutToAppear() {
    // this.fetchStepData()
  }

  // 获取步数数据
  async fetchStepData() {
    const rs = await getStepList()
    console.log('步数结果：', rs)

    const data: StepResponse = JSON.parse(rs)
    if (data.results && data.results.length > 0) {
      this.stepData = data.results[0].step_log
    }
  }

  build() {
    Column() {
      // 日周月
      Row() {
        this.TabItem('日')
        this.TabItem('周')
        this.TabItem('月')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)

      // 日期
      Row() {
        Image($r('app.media.date_left')).width(14).height(14)
        Text(this.dateRange).margin({ left: 50, right: 50 })
          .fontSize(14)
          .fontColor('#666666')
        Image($r('app.media.date_right')).width(14).height(14)
      }.margin({ top: 20 })

      // 累计
      Column() {
        Text('累计').width('100%').padding({ left: 30, top: 30 })
        Text() {
          Span(this.totalSteps.toString()).font({ size: 50 })
          Span('  ')
          Span('步').fontSize(20)
        }
        .width('100%').padding({ left: 30, top: 10 })
      }

    }
  }

  @Builder
  TabItem(text: string) {
    Column() {
      Text(text)
        .fontSize(16).fontColor(text === '周' ? '#5B5FEF' : '#999999').fontWeight(FontWeight.Medium)

      Row()
        .width(24).height(3).margin({ top: 3 })
        .backgroundColor(text === '周' ? '#5B5FEF' : 'transparent')
    }
  }
}

