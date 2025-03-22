import { dataPreferences } from "./DataPreferences"

export const TOKEN_KEY = 'token'

export async function getToken() {
  return await dataPreferences.get(TOKEN_KEY)
}

export async function setToken(token: string) {
  return await dataPreferences.put(TOKEN_KEY, token)
}

export async function deleteToken() {
  return await dataPreferences.delete(TOKEN_KEY)
}