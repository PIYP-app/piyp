import { useEffect, useState } from 'react'
import { Button, StyleSheet } from 'react-native'

import { Text, View } from '../components/Themed'
import AsyncStorage from '@react-native-async-storage/async-storage'
import { createClient, WebDAVClient } from 'webdav'

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold'
  },
  separator: {
    marginVertical: 30,
    height: 1,
    width: '80%'
  }
})

export default function TabOneScreen () {
  const [client, setClient] = useState<WebDAVClient>()

  async function getSettings () {
    try {
      const serverUrl = await AsyncStorage.getItem('serverUrl')
      const username = await AsyncStorage.getItem('username')
      const password = await AsyncStorage.getItem('password')
      if (serverUrl !== null && username !== null && password !== null) {
        setClient(createClient(serverUrl, {
          username,
          password
        }))
      }
    } catch (e) {}
  }

  useEffect(() => {
    getSettings()
  }, [])

  async function getDirectory () {
    try {
      const directoryItems = await client?.getDirectoryContents('/')
      console.log(directoryItems)
    } catch (e) {
      console.log('error: ')
      console.log(e)
    }
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Tab One</Text>
      <Button title='Directories' onPress={() => getDirectory()}/>
    </View>
  )
}
