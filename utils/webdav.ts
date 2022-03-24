import { createClient } from 'webdav'

export async function testConnection (serverUrl: string, username: string, password: string) {
  const client = createClient(serverUrl, { username, password })
  await client?.getDirectoryContents('/')
}
