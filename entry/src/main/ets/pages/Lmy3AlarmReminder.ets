import router from '@ohos.router'
import http from '@ohos.net.http';

interface AlarmItem {
  objectId?: string;
  time: string;
  days: string;
  enabled: boolean;
  createdAt?: string;
  updatedAt?: string;
}

interface AlarmResponse {
  results: AlarmItem[];
}

@Entry
@Component
struct AlarmReminder {
  @State alarmList: AlarmItem[] = [];

  aboutToAppear() {
    this.fetchAlarmData();
  }

  // 获取闹钟数据
  async fetchAlarmData() {
    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(
        'https://api.leancloud.cn/1.1/classes/alarm',
        {
          method: http.RequestMethod.GET,
          header: {
            'X-LC-Id': 'Lk7Ea17CoVWpjbDiMn2Ajc0t-gzGzoHsz',
            'X-LC-Key': 'CzmXtXqi8Zf3pSLFPPaUGqd0',
            'Content-Type': 'application/json'
          }
        }
      );

      if (response.responseCode === 200) {
        const data: AlarmResponse = JSON.parse(response.result.toString());
        this.alarmList = data.results || [];
      }
    } catch (err) {
      console.error('获取闹钟数据失败:', err);
    } finally {
      httpRequest.destroy();
    }
  }

  // 更新闹钟状态
  async updateAlarmStatus(objectId: string, enabled: boolean) {
    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(
        `https://api.leancloud.cn/1.1/classes/alarm/${objectId}`,
        {
          method: http.RequestMethod.PUT,
          header: {
            'X-LC-Id': 'Lk7Ea17CoVWpjbDiMn2Ajc0t-gzGzoHsz',
            'X-LC-Key': 'VDfOAfC5exDYv5PUJWJTBKzS,master',
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({ enabled: enabled })
        }
      );

      if (response.responseCode !== 200) {
        console.error('更新闹钟状态失败:', response.result.toString());
      }
    } catch (err) {
      console.error('更新闹钟状态异常:', JSON.stringify(err));
    } finally {
      httpRequest.destroy();
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        // 返回按钮
        Row() {
          Image($r('app.media.return'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          // 返回到智能播放页面
          router.back()
        })

        // 标题
        Text('闹钟提醒')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 新增按钮
        Text('新增')
          .fontSize(16)
          .fontColor('#5B9EFF')
          .width(40)
          .onClick(() => {
            // 跳转到新增闹钟页面
            router.pushUrl({
              url: 'pages/Lmy4AlarmDetails'
            }).catch((err: Error) => {
              console.error('跳转到闹钟详情页面失败：', JSON.stringify(err))
            })
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 闹钟图标区域
          Column() {
            Image($r('app.media.alarm'))
              .width(100)
              .height(100)
              .fillColor('#FF9933')
              .margin({ bottom: 15 })

            Text('闹钟提醒')
              .fontSize(14)
              .fontColor('#CCCCCC')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 10, bottom: 20 })

          // 闹钟列表
          Column() {
            ForEach(this.alarmList, (alarm: AlarmItem, index: number) => {
              Column() {
                Row() {
                  // 时间
                  Text(alarm.time)
                    .fontSize(32)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')

                  Blank()

                  // 开关
                  Toggle({ type: ToggleType.Switch, isOn: alarm.enabled })
                    .selectedColor('#5B9EFF')
                    .width(48)
                    .height(28)
                    .onChange((isOn: boolean) => {
                      // 更新本地状态
                      const updatedList: AlarmItem[] = [];
                      this.alarmList.forEach(item => {
                        if (item.objectId === alarm.objectId) {
                          updatedList.push({
                            objectId: item.objectId,
                            time: item.time,
                            days: item.days,
                            enabled: isOn,
                            createdAt: item.createdAt,
                            updatedAt: item.updatedAt
                          });
                        } else {
                          updatedList.push(item);
                        }
                      });
                      this.alarmList = updatedList;
                      
                      // 同步更新到 LeanCloud
                      if (alarm.objectId) {
                        this.updateAlarmStatus(alarm.objectId, isOn);
                      }
                    })
                }
                .width('100%')
                .margin({ bottom: 8 })

                // 星期
                Text(alarm.days)
                  .fontSize(12)
                  .fontColor('#999999')
                  .width('100%')
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 20, bottom: 20 })
              .backgroundColor('#FFFFFF')
              .borderRadius(0)
              .margin({ bottom: index < this.alarmList.length - 1 ? 1 : 0 })
            }, (alarm: AlarmItem) => alarm.objectId ?? '')
          }
          .width('100%')
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

