import { get, put } from './request'
import { api_user_info } from '../api'
import { AppKeyHerder, MasterHerder } from '../common/RequestHeader'

// export function getUserInfo(): Promise<string> {
//   return get(api_user_info, AppKeyHerder)
// }

export function updateTarget(target: number) {
  let params = JSON.stringify({ target })
  put(api_user_info, params, MasterHerder)
}