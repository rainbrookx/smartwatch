import { get } from './request'
import { api_user_info } from '../api'
import { AppKeyHerder, MasterHerder } from '../common/RequestHeader'

export function getUserInfo(): Promise<string> {
  return get(api_user_info, AppKeyHerder)
}